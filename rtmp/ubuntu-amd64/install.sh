#!/usr/bin/env bash
set -euo pipefail

APP_NAME="rtmp"
APP_USER="root"
APP_GROUP="root"
INSTALL_DIR="/opt/live/${APP_NAME}"
BIN_PATH="${INSTALL_DIR}/${APP_NAME}"
ENV_PATH="${INSTALL_DIR}/app.env"
SERVICE_PATH="/etc/systemd/system/live-${APP_NAME}.service"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Please run install.sh as root."
  exit 1
fi

if [[ ! -f "${SCRIPT_DIR}/${APP_NAME}" ]]; then
  echo "Deploy artifact not found: ${SCRIPT_DIR}/${APP_NAME}"
  exit 1
fi

mkdir -p "${INSTALL_DIR}/data/state" "${INSTALL_DIR}/logs"

install -m 0755 "${SCRIPT_DIR}/${APP_NAME}" "${BIN_PATH}"

if [[ ! -f "${ENV_PATH}" ]]; then
  install -m 0644 "${SCRIPT_DIR}/app.env.example" "${ENV_PATH}"
fi

cat > "${SERVICE_PATH}" <<EOF
[Unit]
Description=Live rtmp service
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
systemctl enable "live-${APP_NAME}.service"
systemctl restart "live-${APP_NAME}.service"

echo
echo "Install completed."
echo "Service: live-${APP_NAME}.service"
echo "Config: ${ENV_PATH}"
echo "Status:"
systemctl --no-pager --full status "live-${APP_NAME}.service" || true
echo
echo "Check local health:"
echo "curl -H 'X-API-Key: <api_key>' http://127.0.0.1:8080/health"
