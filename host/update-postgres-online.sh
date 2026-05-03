#!/usr/bin/env bash
set -euo pipefail

REPO_OWNER="xiaotianwm"
REPO_NAME="live"
BRANCH="main"
UPDATE_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/host/update-online.sh"

APP_NAME="host"
INSTALL_DIR="/opt/live/${APP_NAME}"
ENV_PATH="${INSTALL_DIR}/app.env"
SERVICE_NAME="live-${APP_NAME}.service"
PROMPT_TTY="/dev/tty"

run_as_root() {
  if [[ "$(id -u)" -eq 0 ]]; then
    "$@"
    return
  fi
  if ! command -v sudo >/dev/null 2>&1; then
    echo "This script is not running as root and sudo is unavailable."
    exit 1
  fi
  sudo "$@"
}

download_to_stdout() {
  local url="$1"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url"
    return
  fi
  if command -v wget >/dev/null 2>&1; then
    wget -qO- "$url"
    return
  fi
  echo "curl or wget is required."
  exit 1
}

prompt_default() {
  local label="$1"
  local default_value="$2"
  local input=""
  read -r -p "${label} [${default_value}]: " input < "${PROMPT_TTY}" || true
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
    read -r -s -p "${label}: " value < "${PROMPT_TTY}" || true
    echo > "${PROMPT_TTY}"
    if [[ -z "${value}" ]]; then
      echo "${label} is required." > "${PROMPT_TTY}"
    fi
  done
  printf '%s' "${value}"
}

echo "Updating host package..."
download_to_stdout "${UPDATE_URL}" | bash

if [[ ! -f "${ENV_PATH}" ]]; then
  echo "Host config not found: ${ENV_PATH}"
  echo "Please install host first."
  exit 1
fi

echo
echo "Configure PostgreSQL for host."
echo "The password input is hidden and will only be written to ${ENV_PATH}."

if [[ ! -r "${PROMPT_TTY}" ]]; then
  echo "No interactive terminal detected. Please run this script from a terminal."
  exit 1
fi

pg_host="$(prompt_required "PostgreSQL host" "")"
pg_port="$(prompt_default "PostgreSQL port" "5432")"
pg_user="$(prompt_required "PostgreSQL user" "")"
pg_password="$(prompt_secret "PostgreSQL password")"
pg_db="$(prompt_default "PostgreSQL database" "live_host")"
pg_bootstrap_db="$(prompt_default "Bootstrap database" "postgres")"
pg_sslmode="$(prompt_default "PostgreSQL sslmode" "require")"
pg_state_key="$(prompt_default "PostgreSQL state key" "default")"

timestamp="$(date +%Y%m%d-%H%M%S)"
run_as_root cp "${ENV_PATH}" "${ENV_PATH}.bak-${timestamp}"

tmp_env="$(mktemp)"
cat > "${tmp_env}" <<EOF
HOST_ADDR=0.0.0.0:18081
HOST_STATIC_DIR=dist
HOST_BASE_PATH=

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
run_as_root install -m 0600 "${tmp_env}" "${ENV_PATH}"
rm -f "${tmp_env}"

echo
echo "Restarting ${SERVICE_NAME} with updated PostgreSQL config..."
run_as_root systemctl restart "${SERVICE_NAME}"

echo
echo "Update and PostgreSQL switch completed."
echo "Config: ${ENV_PATH}"
echo "Backup: ${ENV_PATH}.bak-${timestamp}"
run_as_root systemctl --no-pager --full status "${SERVICE_NAME}" || true
