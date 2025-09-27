#!/bin/bash
# Script de Instalação do SafeSign IC Standard

# Variáveis
URL_SAFESIGN="https://assets.ctfassets.net/zuadwp3l2xby/2loCJpZkGMJe5y06gwzM4C/a065ab00cd0c42ca04de8870dce3de06/SafeSign_IC_Standard_Linux_ub2404_4.2.1.0-AET.000.zip"
ARQUIVO_ZIP="${HOME}/Downloads/SafeSign_IC_Standard_Linux_ub2404_4.2.1.0-AET.000.zip"
ARQUIVO_DEB="${HOME}/Downloads/SafeSign IC Standard Linux 4.2.1.0-AET.000 ub2404 x86_64.deb"
# SHA256 do arquivo zip
CHECKSUM_SAFESIGN="3cf3e94ca8dddefe4e192c2a84a14cbdfd0789271d02d7d323da0b48ecdb8ac7"

echo "Baixando SafeSign IC Standard..."
mkdir -p "${HOME}/Downloads"
wget -P "${HOME}/Downloads" "${URL_SAFESIGN}"

# Verificação de Checksum
echo "Verificando checksum do SafeSign..."
if ! echo "${CHECKSUM_SAFESIGN}  ${ARQUIVO_ZIP}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do SafeSign falhou!"
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Descompactando SafeSign..."
unzip "${ARQUIVO_ZIP}" -d "${HOME}/Downloads"

echo "Instalando SafeSign..."
apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos do SafeSign..."
rm "${ARQUIVO_DEB}" "${ARQUIVO_ZIP}"

echo "Instalação do SafeSign IC Standard concluída."
