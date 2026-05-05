# 2026-05-06 agnet latest logs

## Updated

- Added `POST /api/executions/latest-logs` to fetch latest runtime logs by execution IDs.
- The new endpoint keeps `X-Agent-Key` authentication and does not depend on host, rtmp, or PostgreSQL.
- Missing or stopped execution IDs return `running=false` so callers can distinguish inactive tasks.
- Added a request size limit to avoid oversized batch requests.

## Verification

- `go test ./...`
- `go build ./...`
