#!/usr/bin/env bash
set -euo pipefail
systemctl stop live-agnet.service
systemctl --no-pager --full status live-agnet.service || true
