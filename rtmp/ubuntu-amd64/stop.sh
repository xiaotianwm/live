#!/usr/bin/env bash
set -euo pipefail

systemctl stop live-rtmp.service
systemctl --no-pager --full status live-rtmp.service || true
