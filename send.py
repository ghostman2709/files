import codecs
import hashlib
import pyperclip
import subprocess
from colorama import init, Fore

# Inicializa colorama
init(autoreset=True)

def private_key_to_wif(private_key):
    """Converte uma chave privada em hexadecimal para formato WIF."""
    PK1 = '80' + private_key + '01'  
    PK2 = hashlib.sha256(codecs.decode(PK1, 'hex')).digest()
    PK3 = hashlib.sha256(PK2).digest()
    checksum = codecs.encode(PK3, 'hex').decode()[:8]
    PK4 = PK1 + checksum
    return base58(PK4)

def base58(address_hex):
    """Converte uma string hexadecimal para formato base58."""
    alphabet = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
    address_int = int(address_hex, 16)
    b58_string = ''
    
    # Conta os zeros à esquerda
    leading_zeros = len(address_hex) - len(address_hex.lstrip('0'))

    while address_int > 0:
        digit = address_int % 58
        b58_string = alphabet[digit] + b58_string
        address_int //= 58

    # Adiciona zeros à esquerda como '1's
    return '1' * leading_zeros + b58_string

if __name__ == "__main__":
    private_key_hex = input("Digite a chave privada (hex): ")
    wif = private_key_to_wif(private_key_hex)
    pyperclip.copy(wif)
    print(Fore.GREEN + "Chave WIF (compatível com Electrum):")
    print(Fore.RED + wif)
    print(Fore.GREEN + "A chave WIF foi copiada para a área de transferência.")

    # Inicia o Electrum
    print(Fore.BLUE + "\nIniciando Electrum...")
    subprocess.Popen(["python3", "Electrum-4.5.8/run_electrum"])
