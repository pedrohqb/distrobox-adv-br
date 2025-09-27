#!/bin/bash
# Script de Instalação do Java Zulu 11

# Variáveis
URL_JAVA="https://cdn.azul.com/zulu/bin/zulu11.82.19-ca-jdk11.0.28-linux_amd64.deb"
ARQUIVO_DEB="${HOME}/Downloads/zulu11.82.19-ca-jdk11.0.28-linux_amd64.deb"
# SHA256 do arquivo DEB
CHECKSUM_JAVA="1b5a3799dc5466137f3ef921d8e1ea50471aecbe895fdaf5afff8d722cfe3b37"

echo "Baixando Java Zulu 11..."
wget -P "${HOME}/Downloads" "${URL_JAVA}"

# Verificação de Checksum
echo "Verificando checksum do Java Zulu 11..."
if ! echo "${CHECKSUM_JAVA}  ${ARQUIVO_DEB}" | sha256sum -c --status; then
    echo "ERRO: Checksum SHA256 do Java Zulu 11 falhou!"
    exit 1
fi
echo "Checksum verificado com sucesso."

echo "Instalando Java Zulu 11..."
apt install -y "${ARQUIVO_DEB}"

echo "Limpando arquivos do Java Zulu 11..."
rm "${ARQUIVO_DEB}"

echo "Instalação do Java Zulu 11 concluída."
