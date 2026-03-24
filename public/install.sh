#!/bin/sh
set -e

REPO="abbado-dev/abbado"
INSTALL_DIR="/usr/local/bin"
BINARY="abbado"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

info() { printf "${CYAN}==>${NC} %s\n" "$1"; }
success() { printf "${GREEN}==>${NC} %s\n" "$1"; }
error() { printf "${RED}error:${NC} %s\n" "$1" >&2; exit 1; }

# Detect OS and architecture
detect_target() {
    OS=$(uname -s)
    ARCH=$(uname -m)

    case "$OS" in
        Darwin)
            case "$ARCH" in
                arm64|aarch64) TARGET="aarch64-apple-darwin" ;;
                x86_64)        TARGET="x86_64-apple-darwin" ;;
                *) error "unsupported macOS architecture: $ARCH" ;;
            esac
            ;;
        Linux)
            case "$ARCH" in
                x86_64|amd64)  TARGET="x86_64-unknown-linux-gnu" ;;
                aarch64|arm64) TARGET="aarch64-unknown-linux-gnu" ;;
                *) error "unsupported Linux architecture: $ARCH" ;;
            esac
            ;;
        *) error "unsupported OS: $OS" ;;
    esac
}

# Get latest version from GitHub
get_latest_version() {
    if command -v curl >/dev/null 2>&1; then
        VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
    elif command -v wget >/dev/null 2>&1; then
        VERSION=$(wget -qO- "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
    else
        error "curl or wget required"
    fi

    if [ -z "$VERSION" ]; then
        error "could not determine latest version"
    fi
}

# Download and install
install() {
    ARTIFACT="${BINARY}-${TARGET}.tar.gz"
    URL="https://github.com/${REPO}/releases/download/v${VERSION}/${ARTIFACT}"
    TMPDIR=$(mktemp -d)

    info "installing abbado v${VERSION} (${TARGET})"

    info "downloading ${URL}"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$URL" -o "${TMPDIR}/${ARTIFACT}"
    else
        wget -q "$URL" -O "${TMPDIR}/${ARTIFACT}"
    fi

    info "extracting"
    tar xzf "${TMPDIR}/${ARTIFACT}" -C "${TMPDIR}"

    # Remove quarantine attribute on macOS
    if [ "$(uname -s)" = "Darwin" ]; then
        xattr -d com.apple.quarantine "${TMPDIR}/${BINARY}" 2>/dev/null || true
    fi

    info "installing to ${INSTALL_DIR}/${BINARY}"
    if [ -w "$INSTALL_DIR" ]; then
        mv "${TMPDIR}/${BINARY}" "${INSTALL_DIR}/${BINARY}"
    else
        sudo mv "${TMPDIR}/${BINARY}" "${INSTALL_DIR}/${BINARY}"
    fi
    chmod +x "${INSTALL_DIR}/${BINARY}"

    rm -rf "$TMPDIR"

    success "abbado v${VERSION} installed to ${INSTALL_DIR}/${BINARY}"
    echo ""
    echo "  Run 'abbado' to start the dashboard on http://localhost:4320"
    echo ""
}

detect_target
get_latest_version
install
