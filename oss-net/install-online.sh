#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

CONFIG_FILE="/etc/sysctl.d/99-live-oss-network.conf"
BACKUP_FILE=""

if [[ "${EUID}" -ne 0 ]]; then
  echo -e "${RED}Error: run this script as root${NC}"
  exit 1
fi

echo -e "${GREEN}=== Applying OSS network optimization ===${NC}"

if [[ -f "${CONFIG_FILE}" ]]; then
  BACKUP_FILE="${CONFIG_FILE}.bak.$(date +%F-%H%M%S)"
  cp "${CONFIG_FILE}" "${BACKUP_FILE}"
  echo -e "${YELLOW}Previous config backed up to: ${BACKUP_FILE}${NC}"
fi

cat > "${CONFIG_FILE}" <<'EOF'
# ==========================================
# Live OSS Network Optimization
# ==========================================
# Target:
# - OSS / object storage upload and download traffic
# Strategy:
# - keep stable BBR and buffer tuning
# - do not enable ip_forward
# - do not lower tcp_syn_retries / tcp_synack_retries

net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

net.core.rmem_max = 33554432
net.core.wmem_max = 33554432
net.ipv4.tcp_rmem = 4096 87380 33554432
net.ipv4.tcp_wmem = 4096 16384 33554432
net.ipv4.tcp_window_scaling = 1
net.core.netdev_max_backlog = 5000

net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_keepalive_time = 600
EOF

echo -e "${YELLOW}Applying kernel parameters...${NC}"
sysctl --system >/dev/null

CURRENT_ALGO="$(sysctl -n net.ipv4.tcp_congestion_control 2>/dev/null || true)"
CURRENT_QDISC="$(sysctl -n net.core.default_qdisc 2>/dev/null || true)"

echo
echo -e "${GREEN}=== Verification ===${NC}"
echo -e "Congestion control: ${GREEN}${CURRENT_ALGO:-unknown}${NC}"
echo -e "Queue discipline: ${GREEN}${CURRENT_QDISC:-unknown}${NC}"
echo
echo "Config file: ${CONFIG_FILE}"
if [[ -n "${BACKUP_FILE}" ]]; then
  echo "Backup file: ${BACKUP_FILE}"
fi

if [[ "${CURRENT_ALGO}" == "bbr" && "${CURRENT_QDISC}" == "fq" ]]; then
  echo -e "${GREEN}OK: OSS network optimization is active${NC}"
else
  echo -e "${YELLOW}Warning: config was written, but BBR may not be active. Check kernel support.${NC}"
fi

echo
echo "Useful checks:"
echo "  sysctl net.ipv4.tcp_congestion_control"
echo "  sysctl net.core.default_qdisc"
echo "  sysctl net.ipv4.tcp_rmem"
echo "  sysctl net.ipv4.tcp_wmem"
