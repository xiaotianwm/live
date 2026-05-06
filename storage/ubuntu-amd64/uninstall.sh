#!/usr/bin/env bash
set -euo pipefail

APP_NAME="storage"
INSTALL_DIR="/opt/live/${APP_NAME}"
BIN_PATH="${INSTALL_DIR}/${APP_NAME}"
SERVICE_PATH="/etc/systemd/system/live-${APP_NAME}.service"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Please run uninstall.sh as root."
  exit 1
fi

if systemctl list-unit-files | grep -q "^live-${APP_NAME}.service"; then
  systemctl stop "live-${APP_NAME}.service" || true
  systemctl disable "live-${APP_NAME}.service" || true
fi

rm -f "${SERVICE_PATH}" "${BIN_PATH}"
systemctl daemon-reload
systemctl reset-failed || true

echo
echo "Uninstall completed."
echo "Removed:"
echo "  ${SERVICE_PATH}"
echo "  ${BIN_PATH}"
echo "Preserved:"
echo "  ${INSTALL_DIR}/data"
echo "  ${INSTALL_DIR}/app.env"
