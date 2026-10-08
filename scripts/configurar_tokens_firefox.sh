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
firefox-esr --headless --new-tab about:blank &

# Espera o Firefox criar o perfil (no máximo 30 segundos). A partir do
# Firefox 147 (ESR 153), perfis novos ficam em ~/.config/mozilla/firefox;
# versões anteriores usam ~/.mozilla/firefox.
for i in $(seq 1 30); do
    sleep 1
    if find "$HOME/.config/mozilla/firefox" "$HOME/.mozilla/firefox" -maxdepth 1 \
        -type d -name "*.default-esr" 2>/dev/null | grep -q .; then
        break
    fi
done

# Mata todos os processos do Firefox para garantir que o navegador esteja fechado
pkill -f firefox-esr
echo "Processo do Firefox encerrado."
echo "---"

# --- Passo 1b: Criar ~/.mozilla como link para .config/mozilla ---
# Outros programas ainda procuram ~/.mozilla. O link só pode ser criado
# depois da primeira execução: se ~/.mozilla já existir como link quando o
# Firefox 153 cria o perfil, ele grava o perfil em outra pasta. Criado depois,
# o Firefox continua usando o mesmo perfil em ~/.config/mozilla/firefox.
if [ -d "$HOME/.config/mozilla" ] && [ ! -e "$HOME/.mozilla" ] && [ ! -L "$HOME/.mozilla" ]; then
    ln -s .config/mozilla "$HOME/.mozilla"
    echo "Link criado: ~/.mozilla -> .config/mozilla"
fi

# --- Passo 2: Encontrar o diretório do perfil recém-criado ---
# Procura por perfis que terminam com "default-esr"
CAMINHO_DO_PERFIL=$(find "$HOME/.mozilla/firefox" "$HOME/.config/mozilla/firefox" -maxdepth 1 \
    -type d -name "*.default-esr" 2>/dev/null | head -n 1)

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
