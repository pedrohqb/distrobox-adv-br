#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then 
  echo "Erro: Este script deve ser executado diretamente como root."
  exit 1
fi

# Variáveis dos pacotes
URL_PCSCD="http://launchpadlibrarian.net/722181807/pcscd_2.0.3-1build1_amd64.deb"
URL_LIBPCSC="http://launchpadlibrarian.net/722181806/libpcsclite1_2.0.3-1build1_amd64.deb"
FILE_PCSCD="/tmp/pcscd_2.0.3_amd64.deb"
FILE_LIBPCSC="/tmp/libpcsclite1_2.0.3_amd64.deb"

echo "----------------------------------------------------"
echo "Iniciando instalação de pacotes pcsc (Versão 2.0.3)"
echo "----------------------------------------------------"

# 1. Download dos arquivos para o diretório /tmp
echo ">> Baixando pacotes..."
wget -O "$FILE_PCSCD" "$URL_PCSCD"
wget -O "$FILE_LIBPCSC" "$URL_LIBPCSC"

# 2. Atualização do índice e instalação local
# O apt lida com as dependências automaticamente
echo ">> Instalando pacotes e dependências..."
apt update
apt install -y "$FILE_LIBPCSC" "$FILE_PCSCD"

# 3. Aplicando o hold para evitar atualizações futuras
echo ">> Bloqueando atualizações (apt-mark hold)..."
apt-mark hold pcscd libpcsclite1

# 4. Verificação de sucesso
echo "----------------------------------------------------"
echo "Status atual dos pacotes:"
apt-mark showhold | grep -E 'pcscd|libpcsclite1'
echo "----------------------------------------------------"

# Limpeza
rm "$FILE_PCSCD" "$FILE_LIBPCSC"

echo "Processo concluído."
