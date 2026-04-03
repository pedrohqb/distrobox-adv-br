#!/bin/bash
# Script de Instalação do SafeSign IC Standard

# Variáveis
URL_SAFESIGN="https://assets.ctfassets.net/zuadwp3l2xby/6vGICRnQgQ8TkcHTgcouIr/5acf96dcbc0364aa9228606d3969ef97/SafeSignICStandardLinux4.5.0.0-AET.000ub2404x86_64.deb"
ARQUIVO_DEB="${HOME}/Downloads/SafeSignICStandardLinux4.5.0.0-AET.000ub2404x86_64.deb"

# SHA256 atualizado conforme solicitado
CHECKSUM_SAFESIGN="7742e21e3141e51e307d7613b4046886bc7c4aa203835dcf5c43cd348f2a1b91"

echo "Baixando SafeSign IC Standard (pacote .deb)..."
wget -O "${ARQUIVO_DEB}" "${URL_SAFESIGN}"

# Verificação de Checksum
echo "Verificando checksum do SafeSign..."
if ! echo "${CHECKSUM_SAFESIGN}  ${ARQUIVO_DEB}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do SafeSign falhou!"
    # Remove o arquivo corrompido para evitar confusão em execuções futuras
    rm "${ARQUIVO_DEB}"
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Instalando SafeSign..."
apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos temporários..."
rm "${ARQUIVO_DEB}"

echo "Instalação do SafeSign IC Standard concluída."
