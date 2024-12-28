import os
import time
import random
import string
import subprocess
import signal
import platform

def limpar_tela():
    """Limpa a tela no Windows ou no terminal WSL."""
    if platform.system() == 'Windows':
        os.system('cls')  # Limpa a tela no CMD do Windows
    else:
        os.system('clear')  # Limpa a tela no terminal do WSL ou Linux

def gerar_rnd(tamanho, wallet_file):
    """
    Gera um valor aleatório para o parâmetro -r.
    O valor é composto de um primeiro dígito aleatório e mais
    um número definido de caracteres aleatórios de 1-9 e a-f.
    """
    if wallet_file == '68.txt':
        primeiro_digito = random.choice(['8', 'a', 'b', 'c', 'd', 'e', 'f'])  # Seleção especial para 68.txt
    else:
        primeiro_digito = random.choice(['4', '5', '6', '7'])  # Seleção padrão para outros arquivos

    outros_digitos = ''.join(random.choices(string.digits + 'abcdef', k=tamanho))

    if wallet_file == '71.txt':
        # Quando for 71.txt, garantir que o total seja 17 caracteres
        primeira_parte = (primeiro_digito + outros_digitos).ljust(18, '0')  # Completa com '0' até 18 caracteres
        segunda_parte = (primeiro_digito + outros_digitos).ljust(18, 'f')  # Completa com 'f' até 18 caracteres
    else:
        # Para outros arquivos, mantemos o comportamento anterior
        primeira_parte = (primeiro_digito + outros_digitos).ljust(18 if tamanho == 10 else 17, '0')
        segunda_parte = (primeiro_digito + outros_digitos).ljust(18 if tamanho == 10 else 17, 'f')

    return primeira_parte, segunda_parte  # Retorna as partes geradas

def executar_comando_wsl(primeira_parte, segunda_parte, wallet_file, t_param):
    """
    Função para executar o comando keyhunt dentro do WSL. 
    Utiliza valores aleatórios gerados.
    """
    comando = f"./keyhunt  -m rmd160 -f tests/{wallet_file} -r {primeira_parte}:{segunda_parte} -n 2048 -t {t_param} -k 2048 -e -l compress -R -s 15"
    
    print(f"Executando no WSL: {comando}")  # Mostrar o comando que será executado

    # Usar o bash para rodar o comando no WSL
    comando_wsl = f'bash -c "cd /root/keyhunt && {comando}"'

    # Verificar o sistema operacional para usar o comando correto
    if platform.system() == 'Windows':
        processo = subprocess.Popen(comando_wsl, shell=True, creationflags=subprocess.CREATE_NEW_PROCESS_GROUP)
    else:
        processo = subprocess.Popen(comando_wsl, shell=True, preexec_fn=os.setsid)
    
    return processo

def interromper_processo(processo):
    """
    Função para interromper o processo com Ctrl+C.
    Envia o sinal apropriado para Windows ou WSL.
    """
    if platform.system() == 'Windows':
        processo.send_signal(signal.CTRL_BREAK_EVENT)  # Envia Ctrl+Break no Windows
    else:
        os.killpg(os.getpgid(processo.pid), signal.SIGINT)  # Envia Ctrl+C para o grupo de processos no Linux/WSL

def contagem_regressiva(tempo_em_segundos):
    """
    Exibe a contagem regressiva no terminal.
    """
    while tempo_em_segundos:
        minutos, segundos = divmod(tempo_em_segundos, 60)
        contador = f'{minutos:02d}:{segundos:02d}'
        print(f"\rTempo restante para finalizar: {contador}", end="")
        time.sleep(1)
        tempo_em_segundos -= 1
    print("\nProcesso finalizado.")

def executar_processo(tempo_execucao, tamanho_rnd, wallet_file, t_param, tempo_entre_execucoes):
    """Função para iniciar e finalizar o processo com base no tempo configurado."""
    while True:
        limpar_tela()  # Limpa a tela antes de iniciar o processo
        print("Iniciando o processo...")

        # Geração do valor aleatório
        primeira_parte, segunda_parte = gerar_rnd(tamanho_rnd, wallet_file)

        processo = executar_comando_wsl(primeira_parte, segunda_parte, wallet_file, t_param)  # Executa a opção

        contagem_regressiva(tempo_execucao)  # Faz a contagem regressiva até o tempo limite
        interromper_processo(processo)  # Finaliza o processo ao final da contagem

        print("Processo encerrado.")
        print(f"Aguardando {tempo_entre_execucoes} segundos antes de reiniciar...")
        time.sleep(tempo_entre_execucoes)  # Aguarda o tempo definido antes de reiniciar

def menu():
    """Exibe o menu de opções para executar o Keyhunt."""
    wallet_options = {
        "1": "66.txt",
        "2": "67.rmd",
        "3": "68.txt",
        "4": "69.txt",
        "5": "71.txt"
    }

    while True:
        limpar_tela()  # Limpa a tela no início do menu

        # Exibir o menu
        print("\033[32m")  # Definir cor verde para o texto do menu
        print("=============================")
        print("      Keyhunt Executor      ")
        print("=============================")
        print("1. Iniciar processo")
        print("0. Sair")
        print("=============================")
        print("\033[0m")  # Resetar a cor do texto para o padrão

        opcao = input("Escolha uma opção: ")

        if opcao == '1':
            tempo_execucao = int(input("Digite o tempo de execução (1 a 10000 segundos): "))
            tamanho_rnd = int(input("Quantos caracteres aleatórios (1 a 10): "))
            
            # Menu interativo para seleção do arquivo da wallet
            print("\nEscolha o arquivo da wallet:")
            for key, value in wallet_options.items():
                print(f"{key}. {value}")

            wallet_choice = input("Digite o número da opção: ")
            wallet_file = wallet_options.get(wallet_choice, None)

            if wallet_file:
                t_param = int(input("Digite o valor de -t (1 a 24): "))
                if 1 <= t_param <= 24:
                    tempo_entre_execucoes = int(input("Digite o tempo entre execuções (1 a 125 segundos): "))
                    if 1 <= tempo_entre_execucoes <= 125:
                        executar_processo(tempo_execucao, tamanho_rnd, wallet_file, t_param, tempo_entre_execucoes)  # Executa o processo e retorna ao menu após finalizar
                    else:
                        print("Valor inválido para o tempo entre execuções. Deve ser entre 1 e 125.")
                else:
                    print("Valor inválido para -t. Deve ser entre 1 e 24.")
            else:
                print("Opção inválida para o arquivo da wallet.")

        elif opcao == '0':
            print("Saindo...")
            break

# Executar o menu
menu()
