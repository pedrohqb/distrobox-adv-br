#!/bin/bash
# -------------------------------------------------------------
# Script para Modificar e Instalar Assinador Serpro
# Execute este script como root: sudo ./script_instalacao.sh
# -------------------------------------------------------------

# --- CONFIGURAÇÃO DE PACOTES E URLs ---
SERPRO_URL="https://assinadorserpro.estaleiro.serpro.gov.br/downloads/4.3.2/assinador-serpro_4.3.2_amd64.deb"

SERPRO_DEB=$(basename $SERPRO_URL)
MODIFIED_SERPRO_DEB="${SERPRO_DEB%.deb}_modificado.deb"

# **HASHES SHA256 REAIS**
SERPRO_SHA="0fc4b76549bf82281c43de443a3beefef7059d853b2b1846a410eb543488fe0c"

# --- CONFIGURAÇÃO DE MODIFICAÇÃO DO PACOTE SERPRO ---
ICON_SOURCE="/opt/serpro/tool/serpro-signer/serpro-signer.png"
ICON_DEST="/usr/share/icons/serpro-signer.png" # Novo local dentro do pacote
DESKTOP_FILE="usr/share/applications/serpro-signer.desktop"
ETC_DIR_TO_REMOVE="etc" # Diretório etc dentro do pacote a ser removido

# --- DIRETÓRIOS DE TRABALHO ---
DOWNLOAD_DIR="/tmp/serpro_install_temp"
WORK_DIR="$DOWNLOAD_DIR/serpro-signer-work"

# Garantir que o script pare em qualquer erro
set -e

echo "--- ⚙️ Preparação e Verificação de Permissões ---"
if [[ $EUID -ne 0 ]]; then
    echo "Este script deve ser executado como root (sudo)."
    exit 1
fi

# Cria o diretório de trabalho e muda para ele
mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

# Limpeza de execuções anteriores (evita conflitos)
rm -rf "$WORK_DIR" "$SERPRO_DEB" "$MODIFIED_SERPRO_DEB"

## Função para baixar e checar o checksum
download_and_check() {
    local url=$1
    local expected_sha=$2
    local filename=$(basename $url)
    echo "--- ⬇️ Baixando $filename..."
    
    wget -q --show-progress -O "$filename" "$url"
    
    if [ $? -ne 0 ]; then
        echo "❌ ERRO ao baixar $filename. Abortando."
        exit 1
    fi
    
    echo "--- 🔐 Verificando SHA256 de $filename ---"
    echo "$expected_sha *$filename" | sha256sum -c -
    echo "✅ Checksum verificado com sucesso para $filename."
}

# --- 1. Execução do Download e Verificação ---
download_and_check $SERPRO_URL $SERPRO_SHA

# --- 2. Descompactar o Serpro DEB para Modificação ---
echo "--- 🛠️ Descompactando o pacote Serpro para modificação ---"
mkdir "$WORK_DIR"

# 2a. Extrai o diretório de controle (DEBIAN)
dpkg-deb --control "$SERPRO_DEB" "$WORK_DIR/DEBIAN"
echo "Arquivos de controle (DEBIAN) extraídos."

# 2b. Extrai o arquivo de dados, ignorando proprietário
dpkg-deb --fsys-tarfile "$SERPRO_DEB" | tar -x --no-same-owner -C "$WORK_DIR"
echo "Dados do pacote Serpro extraídos no diretório $WORK_DIR."

# --- 3. Aplicação das Modificações Solicitadas ---

# 3.1. Copiar o ícone
FULL_ICON_SOURCE="$WORK_DIR/$ICON_SOURCE"
FULL_ICON_DEST="$WORK_DIR/$ICON_DEST"

if [ -f "$FULL_ICON_SOURCE" ]; then
    mkdir -p "$(dirname "$FULL_ICON_DEST")"
    mv "$FULL_ICON_SOURCE" "$FULL_ICON_DEST"
    echo "✅ 1. Ícone movido de '$ICON_SOURCE' para '$ICON_DEST'."
else
    echo "❌ AVISO: Ícone de origem ($ICON_SOURCE) NÃO FOI ENCONTRADO."
fi

# 3.2. Alterar o arquivo .desktop
FULL_DESKTOP_FILE="$WORK_DIR/$DESKTOP_FILE"
if [ -f "$FULL_DESKTOP_FILE" ]; then
    # Altera Icon=... para Icon=serpro-signer
    sed -i 's|^Icon=.*|Icon=serpro-signer|g' "$FULL_DESKTOP_FILE"
    echo "✅ 2. Arquivo .desktop alterado para usar **Icon=serpro-signer**."
else
    echo "❌ AVISO: Arquivo .desktop ($DESKTOP_FILE) NÃO FOI ENCONTRADO."
fi

# 3.3. Remover o diretório /etc
ETC_DIR="$WORK_DIR/$ETC_DIR_TO_REMOVE"
if [ -d "$ETC_DIR" ]; then
    rm -rf "$ETC_DIR"
    echo "✅ 3. Diretório '$ETC_DIR' (e seu conteúdo) removido conforme solicitado."
else
    echo "❌ AVISO: O diretório '$ETC_DIR' NÃO FOI ENCONTRADO. Ignorando remoção."
fi

# 3.4. REMOVER O SCRIPT postinst
POSTINST_FILE="$WORK_DIR/DEBIAN/postinst"
if [ -f "$POSTINST_FILE" ]; then
    rm -f "$POSTINST_FILE"
    echo "✅ 4. Script postinst removido."
else
    echo "❌ AVISO: O arquivo '$POSTINST_FILE' NÃO FOI ENCONTRADO. Ignorando remoção do postinst."
fi

# 3.5. REMOVER O SCRIPT postrm
POSTRM_FILE="$WORK_DIR/DEBIAN/postrm"
if [ -f "$POSTRM_FILE" ]; then
    rm -f "$POSTRM_FILE"
    echo "✅ 5. Script postrm removido."
else
    echo "❌ AVISO: O arquivo '$POSTRM_FILE' NÃO FOI ENCONTRADO. Ignorando remoção do postrm."
fi

# Remove os arquivos md5sums e sha256sums para forçar o recálculo
MD5SUMS_FILE="$WORK_DIR/DEBIAN/md5sums"
SHA256SUMS_FILE="$WORK_DIR/DEBIAN/sha256sums"

if [ -f "$MD5SUMS_FILE" ]; then
    rm -f "$MD5SUMS_FILE"
    echo "Arquivo md5sums removido para recálculo."
fi
if [ -f "$SHA256SUMS_FILE" ]; then
    rm -f "$SHA256SUMS_FILE"
    echo "Arquivo sha256sums removido para recálculo."
fi

# --- 4. Reempacotar o Pacote Modificado ---
echo "--- ⚙️ Reempacotando o Pacote Modificado ---"
dpkg-deb -b "$WORK_DIR" "$MODIFIED_SERPRO_DEB"
echo "✅ Novo pacote criado: $MODIFIED_SERPRO_DEB"

# --- 5. Instalar Todos os Pacotes com APT ---
echo "--- ⬇️ Instalando o pacote modificado ---"
# O APT instalará apenas o arquivo Serpro modificado:
apt install -y "./$MODIFIED_SERPRO_DEB"

echo "--- 🧹 6. Limpeza Final ---"
rm -rf "$WORK_DIR" "$SERPRO_DEB" "$MODIFIED_SERPRO_DEB"
echo "✅ Processo finalizado com sucesso! Arquivos temporários excluídos."
