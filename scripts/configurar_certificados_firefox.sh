#!/bin/bash

# --- Configuração das bibliotecas ---
# Defina o caminho para a sua biblioteca SafeSign e o nome do módulo
CAMINHO_SAFESIGN="/usr/lib/libaetpkss.so"
NOME_SAFESIGN="SafeSign"

# Defina o caminho para a sua biblioteca SafeNet e o nome do módulo
CAMINHO_SAFENET="/usr/lib/libeToken.so"
NOME_SAFENET="SafeNet"

# --- Passo 1: Criar um novo perfil do Firefox pela linha de comando ---
echo "Iniciando o Firefox em modo headless para criar um novo perfil (default-esr)..."
firefox --headless --new-tab about:blank &

# Espera por 1 segundo para o Firefox criar os arquivos do perfil
sleep 3

# Mata todos os processos do Firefox para garantir que o navegador esteja fechado
pkill -f firefox-esr
echo "Processo do Firefox encerrado."
echo "---"

# --- Passo 2: Encontrar o diretório do perfil recém-criado ---
# Procura por perfis que terminam com "default-esr"
CAMINHO_DO_PERFIL=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name "*.default-esr")

# Verifica se o perfil foi encontrado
if [ -z "$CAMINHO_DO_PERFIL" ]; then
    echo "Erro: Não foi possível encontrar um perfil default-esr. A operação foi abortada."
    exit 1
fi

echo "Perfil encontrado: ${CAMINHO_DO_PERFIL}"
echo "---"

# --- Passo 3: Adicionar as bibliotecas de segurança ---

# Adicionar SafeSign
echo "Adicionando a biblioteca ${NOME_SAFESIGN}..."
yes | modutil -add "${NOME_SAFESIGN}" -libfile "${CAMINHO_SAFESIGN}" -dbdir "sql:${CAMINHO_DO_PERFIL}"

# Verifica se a adição foi bem-sucedida
if [ $? -eq 0 ]; then
    echo "${NOME_SAFESIGN} adicionado com sucesso."
else
    echo "Erro: Falha ao adicionar ${NOME_SAFESIGN}. Verifique se o caminho da biblioteca está correto."
fi

echo "---"

# Adicionar SafeNet
echo "Adicionando a biblioteca ${NOME_SAFENET}..."
yes | modutil -add "${NOME_SAFENET}" -libfile "${CAMINHO_SAFENET}" -dbdir "sql:${CAMINHO_DO_PERFIL}"

# Verifica se a adição foi bem-sucedida
if [ $? -eq 0 ]; then
    echo "${NOME_SAFENET} adicionado com sucesso."
else
    echo "Erro: Falha ao adicionar ${NOME_SAFENET}. Verifique se o caminho da biblioteca está correto."
fi

echo "---"
echo "Operação concluída. Verifique os resultados acima."
