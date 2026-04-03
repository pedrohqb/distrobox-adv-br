#!/bin/bash
# Script de Instalação do SafeSign IC Standard

# Variáveis
URL_SAFESIGN="https://assets.ctfassets.net/zuadwp3l2xby/6vGICRnQgQ8TkcHTgcouIr/5acf96dcbc0364aa9228606d3969ef97/SafeSignICStandardLinux4.5.0.0-AET.000ub2404x86_64.deb"
ARQUIVO_DEB="${HOME}/Downloads/SafeSignICStandardLinux4.5.0.0-AET.000ub2404x86_64.deb"
# SHA256 do arquivo deb atualizado
CHECKSUM_SAFESIGN="7742e21e3141e51e307d7613b4046886bc7c4aa203835dcf5c43cd348f2a1b91"

echo "Baixando SafeSign IC Standard..."
wget -P "${HOME}/Downloads" "${URL_SAFESIGN}"

# Verificação de Checksum
echo "Verificando checksum do SafeSign..."
if ! echo "${CHECKSUM_SAFESIGN}  ${ARQUIVO_DEB}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do SafeSign falhou!"
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Instalando SafeSign..."
apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos do SafeSign..."
rm "${ARQUIVO_DEB}"

echo "Instalação do SafeSign IC Standard concluída."
