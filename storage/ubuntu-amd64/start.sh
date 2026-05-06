#!/usr/bin/env bash
set -euo pipefail

systemctl start live-storage.service
systemctl --no-pager --full status live-storage.service || true
