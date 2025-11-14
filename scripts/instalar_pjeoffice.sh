#!/bin/bash
# Script de Instalação do PJeOffice

# Variáveis
URL_PJEOFFICE="https://github.com/pedrohqb/pje-office-debian/releases/download/2.5.16u-2/pje-office_2.5.16u-2_amd64.deb"
ARQUIVO_DEB="${HOME}/Downloads/pje-office_2.5.16u-2_amd64.deb"
# SHA256 do arquivo DEB
CHECKSUM_PJEOFFICE="02ee084b311027900f2b79ee8c73e3aa8fb91dfb509e3f7e75c144c37166fe07"

echo "Baixando PJeOffice..."
wget -P "${HOME}/Downloads" "${URL_PJEOFFICE}"

# Verificação de Checksum
echo "Verificando checksum do PJeOffice..."
if ! echo "${CHECKSUM_PJEOFFICE}  ${ARQUIVO_DEB}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do PJeOffice falhou!"
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Instalando PJeOffice..."
apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos do PJeOffice..."
rm "${ARQUIVO_DEB}"

echo "Instalação do PJeOffice concluída."
