import os
import time
import subprocess
import requests
from colorama import init, Fore

# Inicializa o Colorama para saída colorida no terminal
init(autoreset=True)

def run_rckangaroo(start, pubkey):
    """Executa o programa RCKangaroo.exe com os parâmetros fornecidos."""
    rckangaroo_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "RCKangaroo.exe")

    # Verifica se o arquivo RCKangaroo.exe existe
    if not os.path.isfile(rckangaroo_path):
        print(Fore.RED + f"Erro: '{rckangaroo_path}' não encontrado.")
        return

    # Comando para executar o RCKangaroo.exe com os parâmetros fixos
    command = [
        rckangaroo_path,
        "-dp", "16",  # Parâmetro fixo -dp
        "-range", "66",  # Parâmetro fixo -range
        "-start", start,  # Parâmetro de início
        "-pubkey", pubkey  # Parâmetro da chave pública
    ]

    try:
        print(Fore.GREEN + f"Executando RCKangaroo.exe com a chave pública: {pubkey}")
        subprocess.run(command, shell=True, check=True)  # Executa o RCKangaroo.exe com os parâmetros
        run_tx_script()  # Inicia o script tx.py após a execução de RCKangaroo.exe
    except subprocess.CalledProcessError as e:
        print(Fore.RED + f"Erro ao executar RCKangaroo.exe: {e}")

def run_tx_script():
    """Executa o script tx.py na mesma pasta."""
    tx_script_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "tx.py")

    # Verifica se o arquivo tx.py existe
    if not os.path.isfile(tx_script_path):
        print(Fore.RED + f"Erro: '{tx_script_path}' não encontrado.")
        return

    try:
        print(Fore.GREEN + "Executando o script tx.py...")
        subprocess.run(["python", tx_script_path], check=True)  # Executa o script tx.py
    except subprocess.CalledProcessError as e:
        print(Fore.RED + f"Erro ao executar tx.py: {e}")

def save_to_results_file(pubkey):
    """Salva a chave pública no arquivo RESULTS.txt."""
    results_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "RESULTS.txt")

    try:
        with open(results_path, "a") as file:
            file.write(f"pubkey:{pubkey}\n")
        print(Fore.YELLOW + f"Chave pública salva em '{results_path}'.")
    except IOError as e:
        print(Fore.RED + f"Erro ao salvar a chave pública: {e}")

def get_scriptpubkey(wallet):
    """Recupera o scriptpubkey de um endereço de carteira fornecido."""
    while True:
        try:
            url = f'https://blockchain.info/q/pubkeyaddr/{wallet}'
            response = requests.get(url)
            response.raise_for_status()
            pubkey = response.text
            save_to_results_file(pubkey)  # Salva a chave pública no arquivo
            return pubkey
        except requests.exceptions.RequestException:
            print(Fore.RED + '1BY8GQbnueYofwSuFAT3USAhGjPrkxDdW9 67, tentando novamente em 3 segundos...')
            time.sleep(3)

def menu():
    """Exibe o menu principal e processa a entrada do usuário."""
    start = "40000000000000000"  # Parâmetro fixo de início

    while True:
        print(Fore.BLUE + "\nMenu:")
        print(Fore.GREEN + "1. Monitorar Carteira Puzzle 67 (1BY8GQbnueYofwSuFAT3USAhGjPrkxDdW9)")
        print(Fore.GREEN + "2. Monitorar Carteira Puzzle 67 (1HBXe7XAzg91YuNWSA5sZne1YSWrzzrEcE teste minha)")
        print(Fore.RED + "3. Sair")

        choice = input("Escolha uma opção (1-3): ")

        if choice == '1':
            wallet = "1BY8GQbnueYofwSuFAT3USAhGjPrkxDdW9"
            print(Fore.GREEN + f"Verificando endereço de carteira: {wallet}")
            scriptpubkey = get_scriptpubkey(wallet)
            run_rckangaroo(start, scriptpubkey)  # Chama o RCKangaroo.exe diretamente após obter o scriptpubkey

        elif choice == '2':
            wallet = "1HBXe7XAzg91YuNWSA5sZne1YSWrzzrEcE"
            print(Fore.GREEN + f"Verificando endereço de carteira: {wallet}")
            scriptpubkey = get_scriptpubkey(wallet)
            run_rckangaroo(start, scriptpubkey)  # Chama o RCKangaroo.exe diretamente após obter o scriptpubkey

        elif choice == '3':
            print(Fore.GREEN + "Saindo do programa...")
            break
        else:
            print(Fore.RED + "Opção inválida! Por favor, escolha entre 1 e 3.")

if __name__ == "__main__":
    menu()
