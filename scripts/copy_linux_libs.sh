#!/usr/bin/env bash

# ================================
#  Copy shared library dependencies
#  and set RPATH for standalone build
# ================================

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

# --- Validate arguments ---
if [ -z "$1" ] || [ -z "$2" ]; then
    log_error "Usage: $0 <binary_path> <destination_lib_dir>"
    exit 1
fi

BINARY_PATH="$1"
LIB_DIR="$2"

log_info "Target binary: $BINARY_PATH"
log_info "Destination library directory: $LIB_DIR"

# --- Check if binary exists ---
if [ ! -f "$BINARY_PATH" ]; then
    log_error "Binary not found: $BINARY_PATH"
    exit 1
fi

# --- Create lib folder ---
mkdir -p "$LIB_DIR"
if [ $? -eq 0 ]; then
    log_success "Created directory: $LIB_DIR"
else
    log_error "Failed to create directory: $LIB_DIR"
    exit 1
fi

# --- Collect shared library dependencies ---
log_info "Collecting shared library dependencies..."
DEPS=$(ldd "$BINARY_PATH" | grep "=> /" | awk '{print $3}' | sort -u)

if [ -z "$DEPS" ]; then
    log_warn "No shared libraries found — maybe the binary is fully static?"
else
    for LIB in $DEPS; do
        BASENAME=$(basename "$LIB")
        if [ ! -f "$LIB" ]; then
            log_warn "Library not found on system: $LIB"
            continue
        fi
        cp -u "$LIB" "$LIB_DIR/"
        if [ $? -eq 0 ]; then
            log_success "Copied: $BASENAME to $LIB_DIR/"
        else
            log_error "Failed to copy: $BASENAME to $LIB_DIR/"
        fi
    done
fi

log_success "All tasks completed."
