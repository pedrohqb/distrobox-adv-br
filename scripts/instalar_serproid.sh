#!/bin/bash
# Script final para baixar, modificar, verificar, instalar e realizar a limpeza completa.

# --- CONFIGURAÇÃO ---
PACKAGE_NAME="serproid-desktop-2.1.6-amd64.deb"
NEW_PACKAGE_NAME="${PACKAGE_NAME%.deb}_modificado.deb"
URL="https://serprodrive.serpro.gov.br/s/Cc3EbToE9AFq4qX/download"
SHA256SUM="0ffa9ffe5bc343cc758a12f28bd7f08aec4b6e843d1c043baf0b81572461e588"

# Arquivos a serem modificados
ICON_SOURCE="usr/share/serproid-desktop/SerproID.png"
ICON_DEST="usr/share/icons/SerproID.png"
DESKTOP_FILE="usr/share/applications/serproid.desktop"

# Diretório de Trabalho (onde o script será executado e onde os DEBs ficarão)
# O script irá se mover para este diretório.
DOWNLOAD_DIR="$HOME/Downloads"
# Diretório onde o pacote será descompactado
WORK_DIR="$DOWNLOAD_DIR/serproid-desktop-work"

# Garantir que o script pare em qualquer erro
set -e

echo "Diretório de trabalho definido: **$DOWNLOAD_DIR**"
echo "Pacote a ser modificado: $PACKAGE_NAME"

# 0. Mudar para o diretório de trabalho e criar o diretório temporário
mkdir -p "$WORK_DIR"
cd "$DOWNLOAD_DIR"

# Limpeza de execuções anteriores e arquivos residuais
rm -f "$PACKAGE_NAME" "$NEW_PACKAGE_NAME"
rm -rf "$WORK_DIR"

echo "--- ⬇️ 1. Download do Pacote usando wget ---"
# Baixa o arquivo para o diretório atual ($HOME/Downloads)
wget -O "$PACKAGE_NAME" "$URL"
echo "Download concluído."

echo "--- 🔐 2. Verificação do SHA256 ---"
echo "$SHA256SUM  $PACKAGE_NAME" | sha256sum -c -
echo "Checksum verificado com sucesso."

echo "--- 🛠️ 3. Descompactar para Modificação (Correção de Ownership) ---"
mkdir "$WORK_DIR"

# 3a. Extrai o diretório de controle (DEBIAN)
dpkg-deb --control "$PACKAGE_NAME" "$WORK_DIR/DEBIAN"
echo "Arquivos de controle (DEBIAN) extraídos."

# 3b. Extrai o arquivo de dados (data.tar.xz) usando tar, ignorando proprietário
# Isso corrige o erro "Cannot change ownership: Argumento inválido"
dpkg-deb --fsys-tarfile "$PACKAGE_NAME" | tar -x --no-same-owner -C "$WORK_DIR"
echo "Dados do pacote extraídos no diretório $WORK_DIR."

echo "--- 🗑️ 4. Modificações e Remoções de Arquivos ---"

# 4a. Mover/Copiar o Ícone
FULL_ICON_SOURCE="$WORK_DIR/$ICON_SOURCE"
FULL_ICON_DEST="$WORK_DIR/$ICON_DEST"

if [ -f "$FULL_ICON_SOURCE" ]; then
    # Cria o diretório de destino se não existir dentro do WORK_DIR
    mkdir -p "$(dirname "$FULL_ICON_DEST")"
    mv "$FULL_ICON_SOURCE" "$FULL_ICON_DEST"
    echo "✅ Ícone movido de '$ICON_SOURCE' para '$ICON_DEST'."
else
    echo "❌ ERRO: Arquivo de ícone ($ICON_SOURCE) NÃO ENCONTRADO. Abortando."
    rm -rf "$WORK_DIR"
    exit 1
fi

echo "--- 📝 4b. Modificar Arquivo .desktop ---"
FULL_DESKTOP_FILE="$WORK_DIR/$DESKTOP_FILE"

if [ -f "$FULL_DESKTOP_FILE" ]; then
    sed -i 's|^Icon=.*|Icon=SerproID|g' "$FULL_DESKTOP_FILE"
    echo "✅ Arquivo .desktop modificado para usar **Icon=SerproID**."
else
    echo "❌ ERRO: Arquivo .desktop ($DESKTOP_FILE) NÃO ENCONTRADO. Abortando."
    rm -rf "$WORK_DIR"
    exit 1
fi

# --------------------------------------------------
echo "--- 🔗 4c. Criar Link Simbólico (libneoidp11.so) ---"
# O link é criado dentro do diretório de trabalho, no caminho que será instalado (/usr/lib)
# O TARGET é o arquivo existente: /usr/lib/libserproidp11.so
# O LINK_NAME é o novo link: /usr/lib/libneoidp11.so
TARGET="libserproidp11.so"
LINK_NAME="$WORK_DIR/usr/lib/libneoidp11.so"

# Entra no diretório onde o link simbólico deve ser criado (dentro do WORK_DIR)
cd "$WORK_DIR/usr/lib"

# Cria o link simbólico. O target é relativo ao diretório /usr/lib
ln -s "$TARGET" "libneoidp11.so"
echo "✅ Link simbólico criado: **$LINK_NAME** -> **$TARGET**."

# Volta para o diretório de download
cd "$DOWNLOAD_DIR"
# --------------------------------------------------

echo "--- 🗑️ 4d. Excluir Diretório 'etc' Vazio ---"
ETC_DIR="$WORK_DIR/etc"
if [ -d "$ETC_DIR" ]; then
    # Remove o diretório etc/ e todo o seu conteúdo (que deve ser apenas etc/xdg/autostart/*)
    rm -rf "$ETC_DIR"
    echo "✅ Diretório '$ETC_DIR' (e seu conteúdo) removido conforme solicitado."
else
    echo "❌ AVISO: O diretório '$ETC_DIR' NÃO FOI ENCONTRADO, ignorando remoção."
fi

echo "--- 🗑️ 4e. Excluir Scripts postinst e postrm ---"
POSTINST_FILE="$WORK_DIR/DEBIAN/postinst"
POSTRM_FILE="$WORK_DIR/DEBIAN/postrm"

# Remove o arquivo postinst se existir
if [ -f "$POSTINST_FILE" ]; then
    rm -f "$POSTINST_FILE"
    echo "✅ Arquivo **postinst** removido."
else
    echo "❌ AVISO: Arquivo postinst NÃO ENCONTRADO, ignorando remoção."
fi

# Remove o arquivo postrm se existir
if [ -f "$POSTRM_FILE" ]; then
    rm -f "$POSTRM_FILE"
    echo "✅ Arquivo **postrm** removido."
else
    echo "❌ AVISO: Arquivo postrm NÃO ENCONTRADO, ignorando remoção."
fi
# --------------------------------------------------

# Remove o arquivo md5sums para forçar o recálculo pelo dpkg-deb.
MD5SUMS_FILE="$WORK_DIR/DEBIAN/md5sums"
if [ -f "$MD5SUMS_FILE" ]; then
    rm -f "$MD5SUMS_FILE"
    echo "Arquivo $MD5SUMS_FILE removido para forçar o recálculo."
fi

echo "--- ⚙️ 5. Reempacotar o Pacote Modificado ---"
# O novo pacote é criado em $HOME/Downloads
dpkg-deb -b "$WORK_DIR" "$NEW_PACKAGE_NAME"
echo "Novo pacote criado: $NEW_PACKAGE_NAME"

echo "--- ⬇️ 6. Instalar o Novo Pacote DEB ---"
# Usa APT para instalar o arquivo local (./) e resolver dependências automaticamente
apt install -y "$DOWNLOAD_DIR/$NEW_PACKAGE_NAME"

echo "--- 🧹 7. Limpeza Final (Remoção total) ---"
rm -rf "$WORK_DIR" "$PACKAGE_NAME" "$NEW_PACKAGE_NAME"
echo "Arquivos temporários, pacote original e pacote modificado removidos."
echo "✅ Processo finalizado com sucesso! O pacote modificado está instalado e todos os arquivos residuais foram excluídos."
