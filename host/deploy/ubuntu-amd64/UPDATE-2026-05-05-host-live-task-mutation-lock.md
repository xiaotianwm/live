# 2026-05-05 host live task mutation lock

## Updated

- Live task detail remains readable while a task is active.
- Live task edit/delete/start are blocked while status is `running`, `queued`, `starting`, or `stopping`.
- `starting` and `stopping` are now preserved and displayed correctly in the frontend instead of being normalized to `stopped`.
- PostgreSQL task update/delete paths now enforce expected task statuses inside the write path to avoid concurrent mutation races.

## Verification

- `npm.cmd run build`
- `go test ./...`
- `go build ./...`
- Local host health check passed at `http://127.0.0.1:18081/api/health`.
