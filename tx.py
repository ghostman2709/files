import os
import time
import pyperclip
import struct
import hashlib
import ecdsa
import requests

def read_key_file(file_path):
    """Lê os arquivos e extrai a Chave Privada e Pubkey, verificando diferentes formatos."""
    with open(file_path, "r") as file:
        lines = file.readlines()
        private_key = None
        pubkey = None

        for line in lines:
            if os.path.basename(file_path) == "RESULTS.txt":
                # Formato para RESULTS.txt
                if "PRIVATE KEY:" in line:
                    private_key = line.split("PRIVATE KEY:")[1].strip()
                elif "pubkey:" in line:
                    pubkey = line.split("pubkey:")[1].strip()

        return private_key, pubkey

def format_private_key(private_key, source_file):
    """Formata a Chave Privada com 47 zeros à esquerda para Found.txt."""
    if source_file == "RESULTS.txt":
        return private_key  # Retorna a chave como está
    else:
        return private_key  # Mantém chave original para outros arquivos

# --- Parte 1: Criação da transação não assinada ---
class TxOut:
    def __init__(self, amount, address):
        self.amount = struct.pack("<Q", amount)
        self.script = self.create_p2pkh_script(address)

    def create_p2pkh_script(self, address):
        return bytes.fromhex(f"76a914{address}88ac")  # Script P2PKH padrão

class OutPoint:
    def __init__(self, txid, index):
        self.txid = bytes.fromhex(txid)[::-1]
        self.index = struct.pack("<L", index)

class TxIn:
    def __init__(self, outpoint, prev_txout):
        self.outpoint = outpoint
        self.script = prev_txout.script
        self.sequence = b'\xff\xff\xff\xff'

class Transaction:
    def __init__(self, version, txins, txouts, locktime):
        self.version = struct.pack("<L", version)
        self.txins = txins
        self.txouts = txouts
        self.locktime = struct.pack("<L", locktime)

    def serialize(self, sighash_type):
        result = self.version
        result += struct.pack("<B", len(self.txins))
        for txin in self.txins:
            result += txin.outpoint.txid + txin.outpoint.index
            result += struct.pack("<B", len(txin.script)) + txin.script
            result += txin.sequence
        result += struct.pack("<B", len(self.txouts))
        for txout in self.txouts:
            result += txout.amount
            result += struct.pack("<B", len(txout.script)) + txout.script
        result += self.locktime
        result += struct.pack("<L", sighash_type)
        return result

# --- Função para transferir os fundos ---
def transfer(private_key_hex, pub_key_hex):
    print("Iniciando a transferência...")

    print("Aguardando assinatura para enviar a transação...")

    outs = [
        TxOut(580000000, "9800c1f67c9df9b31e68ef794ce71f7934f1b3fd")
    ]

    outpoint = OutPoint("12f34b58b04dfb0233ce889f674781c0e0c7ba95482cca469125af41a78d13b3", 2)
    prev_out = TxOut(603000000, "739437bb3dd6d1983e66629c5f08c70e52769371")
    txin = TxIn(outpoint, prev_out)

    tx = Transaction(1, [txin], outs, 1)
    msg = tx.serialize(sighash_type=1)

    msg_hash = hashlib.sha256(hashlib.sha256(msg).digest()).digest()

    def double_sha256(data):
        return hashlib.sha256(hashlib.sha256(data).digest()).digest()

    def sign_transaction(private_key_bytes, transaction_bytes):
        sk = ecdsa.SigningKey.from_string(private_key_bytes, curve=ecdsa.SECP256k1)
        msg_hash = double_sha256(transaction_bytes)

        while True:
            signature = sk.sign_digest(msg_hash, sigencode=ecdsa.util.sigencode_der)
            if len(signature) == 70:
                break
        return signature

    private_key_bytes = bytes.fromhex(private_key_hex)
    signature_der = sign_transaction(private_key_bytes, msg)

    signature_der_with_suffix = signature_der + bytes([1])

    outpoint_txid = outpoint.txid
    outpoint_index = 2
    sig = signature_der_with_suffix
    pub_key = bytes.fromhex(pub_key_hex)

    script_sig = struct.pack("<B", len(sig)) + sig + struct.pack("<B", len(pub_key)) + pub_key

    version = struct.pack("<L", 1)
    input_count = struct.pack("<B", 1)

    outpoint_serialized = outpoint_txid + struct.pack("<I", outpoint_index)
    sequence = b"\xff\xff\xff\xff"
    locktime = struct.pack("<L", 0)

    output_count = struct.pack("<B", len(outs))
    serialized_outputs = b""
    for txout in outs:
        serialized_outputs += txout.amount + struct.pack("<B", len(txout.script)) + txout.script

    raw_tx = (
        version +
        input_count +
        outpoint_serialized + 
        struct.pack("<B", len(script_sig)) + script_sig +
        sequence +
        output_count +
        serialized_outputs +
        locktime
    )

    txid = double_sha256(raw_tx)[::-1]

    print("Raw TX:", raw_tx.hex())
    print("TXID:", txid.hex())

    pyperclip.copy(raw_tx.hex())
    print("Raw TX copiado para a área de transferência.")

    url = "https://api.blockcypher.com/v1/btc/main/txs/push"
    payload = {
        "tx": raw_tx.hex()
    }

    response = requests.post(url, json=payload)
    
    if response.status_code == 201:
        print("Transação enviada com sucesso!")
        print("Resposta do BlockCypher:", response.json())
    else:
        print("Falha ao enviar a transação.")
        print("Código de status:", response.status_code)
        print("Mensagem de erro:", response.text)

# --- Função para monitorar arquivos --- 
def monitor_files(file_paths):
    """Monitorar os arquivos e imprimir a Chave Privada e pubkey quando aparecerem."""
    print("Monitorando os arquivos em busca da Chave Privada e pubkey...")
    while True:
        for file_path in file_paths:
            if os.path.exists(file_path):
                private_key, pubkey = read_key_file(file_path)

                if private_key and pubkey:
                    formatted_private_key = format_private_key(private_key, os.path.basename(file_path))
                    print(f"Chave Privada: {formatted_private_key}")
                    print(f"pubkey: {pubkey}")

                    pyperclip.copy(formatted_private_key)

                    transfer(formatted_private_key, pubkey)
                    
                    break
        time.sleep(1)

if __name__ == "__main__":
    file_paths = [
        r"C:\Users\dev\Desktop\RADAR6\RESULTS.txt"
    ]
    monitor_files(file_paths)
