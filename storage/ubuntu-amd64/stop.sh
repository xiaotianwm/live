#!/usr/bin/env bash
set -euo pipefail

systemctl stop live-storage.service
systemctl --no-pager --full status live-storage.service || true
