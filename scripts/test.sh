#!/usr/bin/env bash
set -e

# === Colors ===
GREEN="\033[0;32m"
BLUE="\033[0;36m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
WHITE="\033[0m"

CONAN_DIR="$PWD/.conan_install_dir"
CONAN_BIN="$CONAN_DIR/bin"

echo -e "${BLUE}[INFO] Checking Conan installation...${WHITE}"

# Check if Conan folder exists
if [ ! -d "$CONAN_DIR" ]; then
    echo -e "${YELLOW}[INFO] Conan folder not found, installing...${WHITE}"
    INSTALL_CONAN=true
else
    echo -e "${BLUE}[INFO] Conan folder found, checking executable...${WHITE}"
    if [ ! -f "$CONAN_BIN/conan" ]; then
        echo -e "${YELLOW}[WARN] Conan executable not found. Reinstalling...${WHITE}"
        INSTALL_CONAN=true
    fi
fi

if [ "$INSTALL_CONAN" = true ]; then
    echo -e "${BLUE}[INFO] Installing Conan...${WHITE}"
    rm -rf "$CONAN_DIR"
    mkdir -p "$CONAN_DIR"
    python3 -m pip install --upgrade --target "$CONAN_DIR" conan
fi

# Add to PATH
export PATH="$CONAN_BIN:$PATH"
export PYTHONPATH="$CONAN_DIR:$PYTHONPATH"

echo -e "${GREEN}[OK] Conan is ready to use${WHITE}"
conan --version

echo -e "${BLUE}[INFO] Conna build launched${WHITE}"
conan install . -s build_type=Release --build=missing -c tools.system.package_manager:mode=install -c tools.system.package_manager:sudo=True