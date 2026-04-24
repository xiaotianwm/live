#!/usr/bin/env bash
set -euo pipefail
systemctl restart live-host.service
systemctl --no-pager --full status live-host.service || true
