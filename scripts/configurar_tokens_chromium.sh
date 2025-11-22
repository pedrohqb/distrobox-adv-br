#!/bin/bash

# --- Variáveis de Configuração ---
DIRETORIO_NSS="$HOME/.pki/nssdb/"
# Caminhos fornecidos
LIB_SAFESIGN="/usr/lib/libaetpkss.so"
LIB_SAFENET="/usr/lib/libeToken.so"
LIB_SERPROID="/lib/libneoidp11.so"


# --- 1. Criação e Inicialização do Banco de Dados NSS Sem Senha ---

echo "Iniciando a configuração do NSSDB..."
echo "Criando o diretório: $DIRETORIO_NSS"
# Cria o diretório .pki/nssdb se ele não existir
mkdir -p "$DIRETORIO_NSS"

# Inicializa o banco de dados de certificados (NSSDB).
# O parâmetro --empty-password força o banco de dados a ser criado sem senha mestra,
# tornando o processo não-interativo.
echo "Inicializando o banco de dados de segurança NSS (sql:$DIRETORIO_NSS) com senha vazia..."
certutil -N -d "sql:$DIRETORIO_NSS" --empty-password

# --- 2. Adição dos Módulos dos Tokens via modutil ---

echo -e "\nAdicionando módulos PKCS#11..."

# SafeSign (Assinador Eletrônico AET)
echo "-> Adicionando SafeSign ($LIB_SAFESIGN)"
# O comando 'modutil' irá adicionar o módulo PKCS#11 no NSSDB
modutil -dbdir "sql:$DIRETORIO_NSS" -add "SafeSign_AET" -libfile "$LIB_SAFESIGN" -force

# SafeNet (eToken)
echo "-> Adicionando SafeNet ($LIB_SAFENET)"
modutil -dbdir "sql:$DIRETORIO_NSS" -add "SafeNet_eToken" -libfile "$LIB_SAFENET" -force

# SerproID / NeoID
echo "-> Adicionando SerproID/NeoID ($LIB_SERPROID)"
modutil -dbdir "sql:$DIRETORIO_NSS" -add "SerproID_NeoID" -libfile "$LIB_SERPROID" -force

# --- 3. Verificação ---

echo -e "\n--- Verificação de Módulos Instalados ---"
# Lista todos os módulos carregados no banco de dados
modutil -dbdir "sql:$DIRETORIO_NSS" -list

echo -e "\nScript concluído. Os tokens foram registrados no NSSDB sem a necessidade de senha mestra."
