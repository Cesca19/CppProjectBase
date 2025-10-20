#!/usr/bin/env bash
# ================================================================
# Setup Script for Linux - C++ Project Dependencies Installer
# Works with major distributions (apt, dnf, pacman, zypper)
# ================================================================

# --- Colors ---
COLOR_RESET="\033[0m"
COLOR_INFO="\033[1;34m"    # Blue
COLOR_SUCCESS="\033[1;32m" # Green
COLOR_WARN="\033[1;33m"    # Yellow
COLOR_ERROR="\033[1;31m"   # Red

# --- Helper Functions ---
info()
{
  echo -e "${COLOR_INFO}[INFO]${COLOR_RESET} $1"; 
}

success()
{
  echo -e "${COLOR_SUCCESS}[OK]${COLOR_RESET} $1"; 
}

warn()
{ 
  echo -e "${COLOR_WARN}[WARN]${COLOR_RESET} $1"; 
}

error()
{ 
  echo -e "${COLOR_ERROR}[ERROR]${COLOR_RESET} $1"; 
}

# --- Detect Package Manager ---
detect_package_manager() 
{
    if command -v apt >/dev/null 2>&1; then
        PackageManager="apt"
    elif command -v dnf >/dev/null 2>&1; then
        PackageManager="dnf"
    elif command -v pacman >/dev/null 2>&1; then
        PackageManager="pacman"
    elif command -v zypper >/dev/null 2>&1; then
        PackageManager="zypper"
    else
        error "Unsupported Linux distribution. Please install packages manually."
        exit 1
    fi
    info "Detected package manager: ${PackageManager}"
}

# --- Install Package ---
install_package() 
{
    local pkg="$1"

    case "$PackageManager" in
        apt)
            sudo apt update -y && sudo apt install -y "$pkg"
            ;;
        dnf)
            sudo dnf install -y "$pkg"
            ;;
        pacman)
            sudo pacman -Sy --noconfirm "$pkg"
            ;;
        zypper)
            sudo zypper install -y "$pkg"
            ;;
    esac
}

# --- Verify and Install Dependencies ---
check_and_install() 
{
    local name="$1"
    local check_cmd="$2"
    local pkg_name="$3"

    if command -v $check_cmd >/dev/null 2>&1; then
        success "$name is already installed."
    else
        warn "$name not found. Installing..."
        install_package "$pkg_name"
        if command -v $check_cmd >/dev/null 2>&1; then
            success "$name successfully installed."
        else
            error "Failed to install $name. Please install manually."
            exit 1
        fi
    fi
}

# ================================================================
# Main Execution
# ================================================================

echo -e "${COLOR_INFO}========== Linux Environment Setup ==========${COLOR_RESET}"

detect_package_manager

# --- Check for g++ (build essentials) ---
check_and_install "G++" "g++" "build-essential"

# --- Check for Python 3 ---
check_and_install "Python 3" "python3" "python3"

# --- Check for pip ---
if ! command -v pip3 >/dev/null 2>&1; then
    warn "pip not found. Installing..."
    install_package "python3-pip"
else
    success "pip is already installed."
fi

# --- Check for CMake ---
check_and_install "CMake" "cmake" "cmake"

# --- Check for Conan (via pip) ---
if ! command -v conan >/dev/null 2>&1; then
    warn "Conan not found. Installing via pip..."
    python3 -m pip install --upgrade pip setuptools wheel
    python3 -m pip install conan
else
    success "Conan is already installed."
fi

# --- Final Confirmation ---
echo -e "${COLOR_SUCCESS}All dependencies are installed and up to date!${COLOR_RESET}"
