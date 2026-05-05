# 2026-05-06 host live task log display

## Updated

- Live task list now shows normalized runtime log text for active tasks.
- Host keeps an in-memory runtime log cache and polls active task logs every 2 seconds.
- Only user-facing runtime states are kept for the list log column:
  - `正在启动`
  - `帧率 X | 码率 Y | 时长 Z | 速度 W`
  - `推流异常，等待 X 后重试`
- Other agnet runtime messages no longer overwrite the list display log.
- The live task page refreshes the current page every 3 seconds silently, so the latest log column updates without table loading flicker.
- Room name, mode, and status columns were narrowed, and the released width was assigned to the latest log column.

## Verification

- `go test ./...`
- `go build ./...`
- `npm.cmd run build`
- Local host health check: `GET /api/health`
