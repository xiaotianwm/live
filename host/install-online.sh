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
DEPLOY_DIR=""

resolve_deploy_dir() {
  if [[ -f "${WORK_DIR}/host" && -f "${WORK_DIR}/install.sh" ]]; then
    DEPLOY_DIR="${WORK_DIR}"
    return
  fi

  if [[ -f "${WORK_DIR}/deploy/ubuntu-amd64/host" && -f "${WORK_DIR}/deploy/ubuntu-amd64/install.sh" ]]; then
    DEPLOY_DIR="${WORK_DIR}/deploy/ubuntu-amd64"
    return
  fi

  echo "Unable to locate host deploy directory in extracted package."
  exit 1
}

echo "Downloading host package..."
download "${PACKAGE_URL}" "${ARCHIVE_PATH}"

mkdir -p "${WORK_DIR}"
tar -xzf "${ARCHIVE_PATH}" -C "${WORK_DIR}"
resolve_deploy_dir

chmod +x "${DEPLOY_DIR}/host" "${DEPLOY_DIR}/install.sh" "${DEPLOY_DIR}/update.sh" "${DEPLOY_DIR}/uninstall.sh" "${DEPLOY_DIR}/start.sh" "${DEPLOY_DIR}/stop.sh"

echo "Installing host..."
if [[ "$(id -u)" -eq 0 ]]; then
  bash "${DEPLOY_DIR}/install.sh"
else
  if ! command -v sudo >/dev/null 2>&1; then
    echo "This script is not running as root and sudo is unavailable."
    exit 1
  fi
  sudo bash "${DEPLOY_DIR}/install.sh"
fi

echo
echo "Online install completed."
echo "Service status:"
echo "  systemctl status live-host.service"
echo "Logs:"
echo "  journalctl -u live-host.service -f"
