#!/usr/bin/env bash
set -euo pipefail

APP_NAME="agnet"
INSTALL_DIR="/opt/live/${APP_NAME}"
SERVICE_PATH="/etc/systemd/system/live-${APP_NAME}.service"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Please run uninstall.sh as root."
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
echo "Uninstall completed."
echo "Removed:"
echo "  ${SERVICE_PATH}"
echo "  ${INSTALL_DIR}"
