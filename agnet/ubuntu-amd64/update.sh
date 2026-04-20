#!/usr/bin/env bash
set -euo pipefail

APP_NAME="agnet"
APP_USER="root"
APP_GROUP="root"
INSTALL_DIR="/opt/live/${APP_NAME}"
BIN_PATH="${INSTALL_DIR}/${APP_NAME}"
ENV_PATH="${INSTALL_DIR}/app.env"
SERVICE_PATH="/etc/systemd/system/live-${APP_NAME}.service"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Please run update.sh as root."
  exit 1
fi

if [[ ! -f "${SERVICE_PATH}" ]]; then
  echo "Installed service not found: live-${APP_NAME}.service"
  exit 1
fi

if [[ ! -f "${SCRIPT_DIR}/${APP_NAME}" ]]; then
  echo "Deploy artifact not found: ${SCRIPT_DIR}/${APP_NAME}"
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "Installing ffmpeg..."
  apt-get update
  apt-get install -y ffmpeg
fi

mkdir -p "${INSTALL_DIR}"
install -m 0755 "${SCRIPT_DIR}/${APP_NAME}" "${BIN_PATH}"

if [[ ! -f "${ENV_PATH}" ]]; then
  install -m 0644 "${SCRIPT_DIR}/app.env.example" "${ENV_PATH}"
fi

cat > "${SERVICE_PATH}" <<EOF
[Unit]
Description=Live agnet service
After=network.target

[Service]
Type=simple
User=${APP_USER}
Group=${APP_GROUP}
WorkingDirectory=${INSTALL_DIR}
EnvironmentFile=${ENV_PATH}
ExecStart=${BIN_PATH}
Restart=always
RestartSec=3
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl restart "live-${APP_NAME}.service"

echo
echo "Update completed."
systemctl --no-pager --full status "live-${APP_NAME}.service" || true
