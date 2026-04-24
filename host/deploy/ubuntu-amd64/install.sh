#!/usr/bin/env bash
set -euo pipefail

APP_NAME="host"
APP_USER="root"
APP_GROUP="root"
INSTALL_DIR="/opt/live/${APP_NAME}"
BIN_PATH="${INSTALL_DIR}/${APP_NAME}"
ENV_PATH="${INSTALL_DIR}/app.env"
SERVICE_PATH="/etc/systemd/system/live-${APP_NAME}.service"
DATA_DIR="${INSTALL_DIR}/data"
LOG_DIR="${INSTALL_DIR}/logs"
STATIC_DIR="${INSTALL_DIR}/dist"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Please run install.sh as root."
  exit 1
fi

if [[ ! -f "${SCRIPT_DIR}/${APP_NAME}" ]]; then
  echo "Deploy artifact not found: ${SCRIPT_DIR}/${APP_NAME}"
  exit 1
fi

if [[ ! -d "${SCRIPT_DIR}/dist" ]]; then
  echo "Deploy static dir not found: ${SCRIPT_DIR}/dist"
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

mkdir -p "${INSTALL_DIR}" "${DATA_DIR}" "${LOG_DIR}"

install -m 0755 "${SCRIPT_DIR}/${APP_NAME}" "${BIN_PATH}"
rm -rf "${STATIC_DIR}"
mkdir -p "${STATIC_DIR}"
cp -R "${SCRIPT_DIR}/dist/." "${STATIC_DIR}/"

if [[ ! -f "${ENV_PATH}" ]]; then
  if [[ ! -f "${SCRIPT_DIR}/app.env.example" ]]; then
    echo "Example env file not found."
    exit 1
  fi

  prompt_target="/dev/tty"
  if [[ ! -r "${prompt_target}" ]]; then
    echo "No interactive terminal detected. Please run install.sh from a terminal so PostgreSQL settings can be entered."
    exit 1
  fi

  prompt_default() {
    local label="$1"
    local default_value="$2"
    local input=""
    if [[ -r "${prompt_target}" ]]; then
      read -r -p "${label} [${default_value}]: " input < "${prompt_target}" || true
    fi
    if [[ -z "${input}" ]]; then
      input="${default_value}"
    fi
    printf '%s' "${input}"
  }

  prompt_required() {
    local label="$1"
    local default_value="$2"
    local value=""
    while [[ -z "${value}" ]]; do
      value="$(prompt_default "${label}" "${default_value}")"
      if [[ -z "${value}" ]]; then
        echo "${label} is required."
      fi
    done
    printf '%s' "${value}"
  }

  prompt_secret() {
    local label="$1"
    local value=""
    while [[ -z "${value}" ]]; do
      if [[ -r "${prompt_target}" ]]; then
        read -r -s -p "${label}: " value < "${prompt_target}" || true
        echo
      fi
      if [[ -z "${value}" ]]; then
        echo "${label} is required."
      fi
    done
    printf '%s' "${value}"
  }

  echo "Creating ${ENV_PATH}"
  host_addr="$(prompt_default "Host listen address" "0.0.0.0:18081")"
  base_path="$(prompt_default "Base path (blank for root)" "")"
  pg_host="$(prompt_required "PostgreSQL host" "")"
  pg_port="$(prompt_default "PostgreSQL port" "5432")"
  pg_user="$(prompt_required "PostgreSQL user" "")"
  pg_password="$(prompt_secret "PostgreSQL password")"
  pg_db="$(prompt_default "PostgreSQL database" "live_host")"
  pg_bootstrap_db="$(prompt_default "Bootstrap database" "postgres")"
  pg_sslmode="$(prompt_default "PostgreSQL sslmode" "prefer")"
  pg_state_key="$(prompt_default "PostgreSQL state key" "default")"

  cat > "${ENV_PATH}" <<EOF
HOST_ADDR=${host_addr}
HOST_DATA_FILE=${DATA_DIR}/host-state.json
HOST_STATIC_DIR=dist
HOST_BASE_PATH=${base_path}

HOST_POSTGRES_DSN=
HOST_POSTGRES_HOST=${pg_host}
HOST_POSTGRES_PORT=${pg_port}
HOST_POSTGRES_USER=${pg_user}
HOST_POSTGRES_PASSWORD=${pg_password}
HOST_POSTGRES_DB=${pg_db}
HOST_POSTGRES_BOOTSTRAP_DB=${pg_bootstrap_db}
HOST_POSTGRES_SSLMODE=${pg_sslmode}
HOST_POSTGRES_STATE_KEY=${pg_state_key}

HOST_MEDIA_TEST_TIMEOUT=5s
HOST_STORAGE_TEST_WRITE_OBJECT=false
HOST_STORAGE_TEST_OBJECT_PREFIX=host-connectivity-check
EOF
  chmod 600 "${ENV_PATH}"
fi

cat > "${SERVICE_PATH}" <<EOF
[Unit]
Description=Live host service
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
echo "Health check:"
echo "curl http://127.0.0.1:18081/api/health"
