#!/usr/bin/env bash
set -euo pipefail

APP_NAME="agnet"
INSTALL_DIR="/opt/live/${APP_NAME}"
BIN_PATH="${INSTALL_DIR}/${APP_NAME}"
ENV_PATH="${INSTALL_DIR}/app.env"
SERVICE_PATH="/etc/systemd/system/live-${APP_NAME}.service"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "请使用 root 执行 update.sh"
  exit 1
fi

if [[ ! -f "${SERVICE_PATH}" ]]; then
  echo "未检测到已安装服务: live-${APP_NAME}.service"
  exit 1
fi

if [[ ! -f "${SCRIPT_DIR}/${APP_NAME}" ]]; then
  echo "未找到部署产物: ${SCRIPT_DIR}/${APP_NAME}"
  exit 1
fi

mkdir -p "${INSTALL_DIR}"
install -m 0755 "${SCRIPT_DIR}/${APP_NAME}" "${BIN_PATH}"

if [[ ! -f "${ENV_PATH}" ]]; then
  install -m 0644 "${SCRIPT_DIR}/app.env.example" "${ENV_PATH}"
fi

systemctl daemon-reload
systemctl restart "live-${APP_NAME}.service"

echo
echo "更新完成"
systemctl --no-pager --full status "live-${APP_NAME}.service" || true
