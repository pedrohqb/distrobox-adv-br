#!/bin/bash
# Script de Instalação do PJeOffice

# Variáveis
URL_PJEOFFICE="https://github.com/pedrohqb/pje-office-debian/releases/download/2.5.16u-1/pje-office_2.5.16u-1_amd64.deb"
ARQUIVO_DEB="${HOME}/Downloads/pje-office_2.5.16u-1_amd64.deb"
# SHA256 do arquivo DEB
CHECKSUM_PJEOFFICE="47f1bfe903f06a40b0287e57fa692f8d8fbe82541f582b9b298de1dd3e1bf4e5"

echo "Baixando PJeOffice..."
mkdir -p "${HOME}/Downloads"
wget -P "${HOME}/Downloads" "${URL_PJEOFFICE}"

# Verificação de Checksum
echo "Verificando checksum do PJeOffice..."
if ! echo "${CHECKSUM_PJEOFFICE}  ${ARQUIVO_DEB}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do PJeOffice falhou!"
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Instalando PJeOffice..."
apt update && apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos do PJeOffice..."
rm "${ARQUIVO_DEB}"

echo "Instalação do PJeOffice concluída."
