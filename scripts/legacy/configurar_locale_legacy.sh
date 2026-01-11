#!/bin/bash
# Script de configuração do locale pt_BR.UTF-8

# 1. Verifica se o usuário é root
if [ "$EUID" -ne 0 ]; then 
  echo "Erro: Por favor, execute este script como root ou usando sudo."
  exit 1
fi

# 2. Caminho do arquivo
LOCALE_FILE="/etc/locale.gen"

# 3. Faz um backup de segurança antes de editar
cp "$LOCALE_FILE" "$LOCALE_FILE.bak"
echo "Backup criado em: $LOCALE_FILE.bak"

# 4. Descomenta a linha pt_BR.UTF-8 UTF-8
# O sed procura por linhas que começam com # e contenham pt_BR.UTF-8 UTF-8, removendo o #
sed -i 's/^# *pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' "$LOCALE_FILE"

# 5. Roda o comando locale-gen
echo "Gerando locales..."
locale-gen

echo "------------------------------------------------"
echo "Sucesso! O locale pt_BR.UTF-8 foi configurado."
echo "Locales ativos no sistema:"
locale -a | grep pt_BR
