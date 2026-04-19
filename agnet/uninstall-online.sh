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

  echo "缺少 curl 或 wget，无法下载安装包"
  exit 1
}

ensure_unzip() {
  if command -v unzip >/dev/null 2>&1; then
    return
  fi

  echo "安装 unzip..."
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

  echo "缺少 unzip，且当前无法提权安装"
  exit 1
}

ensure_unzip

ZIP_PATH="${TMP_DIR}/agnet-ubuntu-amd64.zip"
WORK_DIR="${TMP_DIR}/agnet"

echo "下载 agnet 卸载包..."
download "${PACKAGE_URL}" "${ZIP_PATH}"

mkdir -p "${WORK_DIR}"
unzip -q "${ZIP_PATH}" -d "${WORK_DIR}"

chmod +x "${WORK_DIR}/uninstall.sh"

echo "开始卸载..."
if [[ "$(id -u)" -eq 0 ]]; then
  bash "${WORK_DIR}/uninstall.sh"
else
  if ! command -v sudo >/dev/null 2>&1; then
    echo "当前不是 root，且系统没有 sudo，无法继续卸载"
    exit 1
  fi
  sudo bash "${WORK_DIR}/uninstall.sh"
fi

echo
echo "一键卸载完成"
