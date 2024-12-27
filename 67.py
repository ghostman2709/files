import random
import os
import time
import subprocess
import signal
import sys

# Variável global para armazenar o processo em execução
processo = None

def gerar_digitos_iniciais(qtd_digitos):
    """Gera uma sequência de dígitos aleatórios, com o primeiro entre 4 e 7."""
    primeiro_digito = random.choice("4567")  # Escolhe entre 4xx7
    outros_digitos = ''.join(random.choice("0123456789abcdef") for _ in range(qtd_digitos - 1))
    return primeiro_digito + outros_digitos

def modificar_parametros(qtd_digitos):
    """Modifica os parâmetros -begr e -endr com base nos dígitos gerados."""
    begr_inicial = "40000000000000000"
    endr_inicial = "7ffffffffffffffff"

    novos_digitos = gerar_digitos_iniciais(qtd_digitos)
    novo_begr = novos_digitos + begr_inicial[qtd_digitos:]
    novo_endr = novos_digitos + endr_inicial[qtd_digitos:]

    return novo_begr, novo_endr

def encerrar_processo():
    """Encerra todos os processos VBCr.exe em execução."""
    global processo
    # Encerra o processo local atual
    if processo and processo.poll() is None:
        print("\nEncerrando processo atual...")
        try:
            processo.terminate()  # Encerra normalmente
            processo.wait(timeout=3)  # Aguarda até 3 segundos
        except Exception as e:
            print(f"Erro ao encerrar processo: {e}")
        finally:
            processo = None  # Limpa a referência ao processo atual

    # Encerra qualquer processo residual VBCr.exe
    print("\nVerificando e encerrando processos residuais VBCr.exe...")
    if os.name == 'nt':  # Windows
        os.system("taskkill /f /im VBCr.exe >nul 2>&1")
    else:  # Linux/Unix (caso necessário)
        os.system("pkill -9 VBCr.exe")

def executar_vbcr(novo_begr, novo_endr):
    """Executa o comando VBCr.exe com os parâmetros fornecidos."""
    global processo
    comando = [
        "tool.exe", "-t", "0", "-gpu", "-gpuId", "0", "-g", "1024,512",
        "-begr", novo_begr, "-endr", novo_endr,
        "-dis", "1", "-r", "50000", "-drk", "0",
        "-o", "Found.txt", "1BY8GQbnueY"
        
    ]

    print(f"\nExecutando: {' '.join(comando)}")

    # Encerra processos anteriores
    encerrar_processo()

    # Aguarda 3 segundos antes de iniciar um novo processo
    time.sleep(5)
    os.system('cls' if os.name == 'nt' else 'clear')

    # Inicia o novo processo sem shell=True
    try:
        processo = subprocess.Popen(comando)
    except Exception as e:
        print(f"Erro ao iniciar o processo: {e}")
    return processo

def signal_handler(sig, frame):
    """Manipulador para Ctrl+C (SIGINT)."""
    print("\nCtrl+C detectado. Finalizando o programa...")
    encerrar_processo()
    sys.exit(0)

# Registra o manipulador de sinal para Ctrl+C
signal.signal(signal.SIGINT, signal_handler)

def tempo_intervalo_aleatorio():
    """Gera um tempo de intervalo aleatório entre 2 e 5 minutos (em segundos)."""
    return random.randint(3, 5) * 60  # Tempo em segundos

def qtd_digitos_aleatorio():
    """Gera uma quantidade aleatória de dígitos (entre 1 e 7)."""
    return random.randint(2, 5)

if __name__ == "__main__":
    print("Bem-vindo ao programa VBCr Controller!")

    try:
        while True:
            intervalo = tempo_intervalo_aleatorio()
            qtd_digitos = qtd_digitos_aleatorio()

            print(f"\nNovo intervalo de {intervalo // 60} minutos e {qtd_digitos} dígitos aleatórios.")
            novo_begr, novo_endr = modificar_parametros(qtd_digitos)
            executar_vbcr(novo_begr, novo_endr)

            print(f"\nAguardando {intervalo // 60} minutos antes de reiniciar...")
            time.sleep(intervalo)
    except KeyboardInterrupt:
        signal_handler(None, None)
