#!/usr/bin/env bash
set -euo pipefail

REPO_OWNER="xiaotianwm"
REPO_NAME="live"
BRANCH="main"
PACKAGE_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/agnet/agnet-ubuntu-amd64.zip"

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

ensure_unzip() {
  if command -v unzip >/dev/null 2>&1; then
    return
  fi

  echo "Installing unzip..."
  if [[ "$(id -u)" -eq 0 ]]; then
    apt-get update
    apt-get install -y unzip
    return
  fi

  if command -v sudo >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y unzip
    return
  fi

  echo "unzip is required and could not be installed automatically."
  exit 1
}

ensure_unzip

ZIP_PATH="${TMP_DIR}/agnet-ubuntu-amd64.zip"
WORK_DIR="${TMP_DIR}/agnet"

echo "Downloading agnet package..."
download "${PACKAGE_URL}" "${ZIP_PATH}"

mkdir -p "${WORK_DIR}"
unzip -q "${ZIP_PATH}" -d "${WORK_DIR}"

chmod +x "${WORK_DIR}/agnet" "${WORK_DIR}/install.sh" "${WORK_DIR}/start.sh" "${WORK_DIR}/stop.sh"

echo "Installing agnet..."
if [[ "$(id -u)" -eq 0 ]]; then
  bash "${WORK_DIR}/install.sh"
else
  if ! command -v sudo >/dev/null 2>&1; then
    echo "This script is not running as root and sudo is unavailable."
    exit 1
  fi
  sudo bash "${WORK_DIR}/install.sh"
fi

echo
echo "Online install completed."
echo "Service status:"
echo "  systemctl status live-agnet.service"
echo "Logs:"
echo "  journalctl -u live-agnet.service -f"
