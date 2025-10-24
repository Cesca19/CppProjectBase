#!/usr/bin/env bash

# ==============================
#  Linux Dev Environment Setup
#  Checks and installs:
#  g++, cmake, python3, pip, conan
#  Compatible with APT, DNF, YUM, PACMAN
# ==============================

set -e

# --- Colors ---
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[1;34m"
RESET="\033[0m"

# --- Logging functions ---
log_info()    { echo -e "${BLUE}[INFO]${RESET} $1"; }
log_success() { echo -e "${GREEN}[OK]${RESET} $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${RESET} $1"; }
log_error()   { echo -e "${RED}[ERROR]${RESET} $1"; }

# --- Help ---
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Usage: ./scripts/build_linux.sh [BUILD_TYPE] | --help"
    echo
    echo "  BUILD_TYPE can be:"
    echo "    Debug     - Build with debug symbols"
    echo "    Release   - Build optimized release"
    echo
    echo "Examples:"
    echo "  ./scripts/build_linux.sh Debug"
    echo "  ./scripts/build_linux.sh Release"
    exit 0
fi

# --- Determine build type ---
BUILD_TYPE=Debug
if [[ "$1" == "Release" ]]; then
    BUILD_TYPE=Release
fi
VIRTUAL_ENV_NAME=".conan_venv"

log_info "Build type selected: ${BUILD_TYPE}"

# --- Detect package manager ---
if command -v apt-get &>/dev/null; then
    PKG_MANAGER="apt-get"
    UPDATE_CMD="sudo apt-get update -y"
    INSTALL_CMD="sudo apt-get install -y"
elif command -v dnf &>/dev/null; then
    PKG_MANAGER="dnf"
    UPDATE_CMD="sudo dnf check-update || true"
    INSTALL_CMD="sudo dnf install -y"
elif command -v yum &>/dev/null; then
    PKG_MANAGER="yum"
    UPDATE_CMD="sudo yum check-update || true"
    INSTALL_CMD="sudo yum install -y"
elif command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
    UPDATE_CMD="sudo pacman -Sy"
    INSTALL_CMD="sudo pacman -S --noconfirm"
else
    log_error "No supported package manager found (apt, dnf, yum, pacman)."
    exit 1
fi

log_info "Detected package manager: $PKG_MANAGER"

# --- Update repositories ---
log_info "Updating package lists..."
if ! eval $UPDATE_CMD; then
    log_error "Failed to update package lists."
    exit 1
fi

# --- Helper for installation ---
install_package() {
    local package="$1"
    log_info "Installing $package..."
    if ! $INSTALL_CMD "$package"; then
        log_error "Failed to install $package."
        exit 1
    fi
    log_success "$package installed successfully."
}

# --- g++ ---
if ! command -v g++ &>/dev/null; then
    log_warn "g++ not found. Installing build tools..."
    if [[ "$PKG_MANAGER" == "apt-get" ]]; then
        install_package "build-essential"
    else
        install_package "g++"
    fi
else
    log_success "g++ is already installed."
fi

# -- patchelf for linux binary dependencies
install_package "patchelf"

# --- pkg-config ---
if ! command -v pkg-config &>/dev/null; then
    log_warn "pkg-config not found. Installing..."
    if [[ "$PKG_MANAGER" == "apt-get" ]]; then
        install_package "pkg-config"
    elif [[ "$PKG_MANAGER" == "dnf" || "$PKG_MANAGER" == "yum" ]]; then
        install_package "pkgconf-pkg-config"
    elif [[ "$PKG_MANAGER" == "pacman" ]]; then
        install_package "pkgconf"
    fi
else
    log_success "pkg-config is already installed."
fi

# --- CMake ---
if ! command -v cmake &>/dev/null; then
    log_warn "CMake not found. Installing..."
    install_package "cmake"
else
    log_success "CMake is already installed."
fi

# --- Python3 ---
if ! command -v python3 &>/dev/null; then
    log_warn "Python3 not found. Installing..."
    install_package "python3"
else
    log_success "Python3 is already installed."
fi

# --- Python version ---
PY_VER=$(python3 -c "import sys; print('.'.join(map(str, sys.version_info[:2])))")
log_info "Detected Python version: $PY_VER"
if ! python3 -c "import sys; sys.exit(0 if sys.version_info >= (3,7) else 1)"; then
    log_error "Python version must be >= 3.7."
    exit 1
fi
log_success "Python version is compatible."

# --- pip ---
if ! command -v pip3 &>/dev/null; then
    log_warn "pip not found. Installing..."
    install_package "python3-pip"
else
    log_success "pip is already installed."
fi

# --- Remove build and bin folders ---
chmod +x ./scripts/clean_linux.sh
./scripts/clean_linux.sh

# --- Create virtual environment ---
if [ ! -d $VIRTUAL_ENV_NAME ]; then
    log_info "Creating Python virtual environment..."
    if ! python3 -m venv $VIRTUAL_ENV_NAME 2>/tmp/venv_error.log; then
        log_warn "Virtual environment creation failed. Checking for python3-venv package..."
        if [[ "$PKG_MANAGER" == "apt-get" ]]; then
            install_package "python3-venv"
            log_info "Retrying virtual environment creation..."
            if ! python3 -m venv $VIRTUAL_ENV_NAME; then
                log_error "Failed to create virtual environment even after installing python3-venv."
                cat /tmp/venv_error.log
                exit 1
            fi
        else
            log_error "Your system may require python3-venv or equivalent package. Please install it manually."
            cat /tmp/venv_error.log
            exit 1
        fi
    fi
    log_success "Virtual environment successfully created."
else
    log_info "Virtual environment already exists."
fi

# --- Activate virtual environment ---
source $VIRTUAL_ENV_NAME/bin/activate
log_info "Virtual environment activated."

# --- Check Conan installation or update ---
if ! command -v conan &>/dev/null; then
    log_warn "Conan not found in virtual environment. Installing via pip..."
    if ! pip install --upgrade pip; then
        log_error "Failed to upgrade pip."
        exit 1
    fi
    if ! pip install conan; then
        log_error "Failed to install Conan."
        exit 1
    fi
    log_success "Conan successfully installed."
else
    log_info "Conan detected in virtual environment. Checking for updates..."
    
    # Check for outdated Conan version
    OUTDATED=$(pip list --outdated 2>/dev/null | grep -i "^conan " || true)
    if [[ -n "$OUTDATED" ]]; then
        log_warn "A new version of Conan is available. Updating..."
        if ! pip install --upgrade conan; then
            log_error "Failed to update Conan."
            exit 1
        fi
        log_success "Conan successfully updated to the latest version."
    else
        log_success "Conan is already up-to-date."
    fi
fi

log_success "All dependencies are installed and ready!"

# --- Conan profile detection ---
log_info "Configuring Conan profile"
if ! conan profile detect --force; then
    log_error "Conan profile detection failed."
    exit 1
fi
log_success "Conan profile successfully configured."

# --- Conan dependency installation ---
log_info "Installing dependencies with Conan (${BUILD_TYPE})"
if ! conan install . -s build_type=${BUILD_TYPE} --build=missing -c tools.system.package_manager:mode=install -c tools.system.package_manager:sudo=True; then
    log_error "Conan dependency installation failed."
    exit 1
fi
log_success "Conan dependencies installed successfully."

# --- Configure CMake ---
log_info "Configuring project with CMake (${BUILD_TYPE})"
mkdir -p build && cd build
if ! cmake .. -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -DCMAKE_RUNTIME_OUTPUT_DIRECTORY=bin ; then
    log_error "CMake configuration failed."
    exit 1
fi
log_success "CMake configuration successful."

# --- Build project ---
log_info "Building project (${BUILD_TYPE})"
if ! cmake --build . --config ${BUILD_TYPE}; then
    log_error "Build failed."
    exit 1
fi