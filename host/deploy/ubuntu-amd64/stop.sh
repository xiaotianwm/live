#!/usr/bin/env bash
set -euo pipefail
systemctl stop live-host.service
systemctl --no-pager --full status live-host.service || true
