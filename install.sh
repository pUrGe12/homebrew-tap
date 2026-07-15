#!/bin/sh
# Install the Macrohill CLI (Linux/macOS, x64/arm64).
#
#   curl -fsSL https://raw.githubusercontent.com/pUrGe12/homebrew-tap/main/install.sh | sh
#
# Env overrides:
#   MACROHILL_VERSION   pin a version, e.g. 0.1.0 (default: latest)
#   MACROHILL_BIN_DIR   install directory (default: /usr/local/bin, else ~/.local/bin)
set -eu

REPO="pUrGe12/homebrew-tap"

info() { printf '%s\n' "$*" >&2; }
err()  { printf 'error: %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

have curl || err "curl is required"

# --- detect platform ---
os=$(uname -s)
case "$os" in
  Linux)  os=linux ;;
  Darwin) os=macos ;;
  *)      err "unsupported OS: $os" ;;
esac
arch=$(uname -m)
case "$arch" in
  x86_64|amd64)  arch=x64 ;;
  aarch64|arm64) arch=arm64 ;;
  *)             err "unsupported architecture: $arch" ;;
esac
asset="macrohill-${os}-${arch}"

# --- resolve version -> tag ---
ver="${MACROHILL_VERSION:-latest}"
if [ "$ver" = "latest" ]; then
  tag=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
        | grep '"tag_name"' | head -1 | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')
  [ -n "${tag:-}" ] || err "could not resolve the latest release"
else
  case "$ver" in v*) tag="$ver" ;; *) tag="v$ver" ;; esac
fi

base="https://github.com/${REPO}/releases/download/${tag}"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

info "Downloading macrohill ${tag} (${os}-${arch})..."
curl -fsSL "${base}/${asset}" -o "${tmp}/macrohill" || err "download failed: ${base}/${asset}"

# --- verify checksum (best effort) ---
if curl -fsSL "${base}/SHASUMS256.txt" -o "${tmp}/sums" 2>/dev/null; then
  want=$(grep " ${asset}\$" "${tmp}/sums" | awk '{print $1}' | head -1)
  if [ -n "${want:-}" ]; then
    if   have sha256sum; then got=$(sha256sum "${tmp}/macrohill" | awk '{print $1}')
    elif have shasum;    then got=$(shasum -a 256 "${tmp}/macrohill" | awk '{print $1}')
    else got=""; info "note: no sha256 tool found, skipping checksum verification"; fi
    [ -z "${got}" ] || [ "$got" = "$want" ] || err "checksum mismatch for ${asset}"
  fi
fi
chmod +x "${tmp}/macrohill"

# --- install ---
bindir="${MACROHILL_BIN_DIR:-/usr/local/bin}"
if [ -d "$bindir" ] && [ -w "$bindir" ]; then
  mv "${tmp}/macrohill" "${bindir}/macrohill"
elif [ "$(id -u)" != 0 ] && have sudo; then
  info "Installing to ${bindir} (sudo)..."
  sudo mv "${tmp}/macrohill" "${bindir}/macrohill"
else
  bindir="${HOME}/.local/bin"
  mkdir -p "$bindir"
  mv "${tmp}/macrohill" "${bindir}/macrohill"
  info "Installed to ${bindir} — make sure it is on your PATH."
fi

info "✓ macrohill ${tag} installed → ${bindir}/macrohill"
info "  next: macrohill login"
