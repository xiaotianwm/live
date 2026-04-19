#!/usr/bin/env bash
set -euo pipefail

APP_NAME="agnet"
INSTALL_DIR="/opt/live/${APP_NAME}"
SERVICE_PATH="/etc/systemd/system/live-${APP_NAME}.service"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "请使用 root 执行 uninstall.sh"
  exit 1
fi

if systemctl list-unit-files | grep -q "^live-${APP_NAME}.service"; then
  systemctl stop "live-${APP_NAME}.service" || true
  systemctl disable "live-${APP_NAME}.service" || true
fi

rm -f "${SERVICE_PATH}"
systemctl daemon-reload
systemctl reset-failed || true

rm -rf "${INSTALL_DIR}"

echo
echo "卸载完成"
echo "已移除:"
echo "  ${SERVICE_PATH}"
echo "  ${INSTALL_DIR}"
