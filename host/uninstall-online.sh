#!/usr/bin/env bash
set -euo pipefail

REPO_OWNER="xiaotianwm"
REPO_NAME="live"
BRANCH="main"
PACKAGE_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/host/host-ubuntu-amd64.tar.gz"

TMP_DIR="$(mktemp -d)"
CLEANUP_DONE="false"

cleanup() {
  if [[ "${CLEANUP_DONE}" == "false" && -d "${TMP_DIR}" ]]; then
    rm -rf "${TMP_DIR}"
    CLEANUP_DONE="true"
  fi
}
trap cleanup EXIT

download() {
  local url="$1"
  local output="$2"

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$output"
    return
  fi

  if command -v wget >/dev/null 2>&1; then
    wget -qO "$output" "$url"
    return
  fi

  echo "curl or wget is required to download the package."
  exit 1
}

ensure_tar() {
  if command -v tar >/dev/null 2>&1; then
    return
  fi

  echo "Installing tar..."
  if [[ "$(id -u)" -eq 0 ]]; then
    apt-get update
    apt-get install -y tar
    return
  fi

  if command -v sudo >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y tar
    return
  fi

  echo "tar is required and could not be installed automatically."
  exit 1
}

ensure_tar

ARCHIVE_PATH="${TMP_DIR}/host-ubuntu-amd64.tar.gz"
WORK_DIR="${TMP_DIR}/host"

echo "Downloading host package..."
download "${PACKAGE_URL}" "${ARCHIVE_PATH}"

mkdir -p "${WORK_DIR}"
tar -xzf "${ARCHIVE_PATH}" -C "${WORK_DIR}"

chmod +x "${WORK_DIR}/uninstall.sh"

echo "Uninstalling host..."
if [[ "$(id -u)" -eq 0 ]]; then
  bash "${WORK_DIR}/uninstall.sh"
else
  if ! command -v sudo >/dev/null 2>&1; then
    echo "This script is not running as root and sudo is unavailable."
    exit 1
  fi
  sudo bash "${WORK_DIR}/uninstall.sh"
fi

echo
echo "Online uninstall completed."
