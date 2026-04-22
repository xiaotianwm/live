#!/usr/bin/env bash
set -euo pipefail

systemctl start live-rtmp.service
systemctl --no-pager --full status live-rtmp.service || true
