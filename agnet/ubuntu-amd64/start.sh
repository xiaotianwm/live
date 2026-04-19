#!/usr/bin/env bash
set -euo pipefail
systemctl start live-agnet.service
systemctl --no-pager --full status live-agnet.service || true
