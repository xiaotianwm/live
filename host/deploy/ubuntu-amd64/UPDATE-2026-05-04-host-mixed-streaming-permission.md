# Host Update - 2026-05-04 - Mixed Streaming Permission

## Updated

- Added a per-user `allow_mixed_streaming` PostgreSQL permission flag.
- Added admin-side user management control for enabling mixed streaming on normal users.
- Hid the audio file page entry for users without mixed streaming permission.
- Redirected direct visits to `/files/audios` when the current user has no mixed streaming permission.
- Hid the `视频+随机音频` live task mode from users without mixed streaming permission.
- Enforced backend permission checks for audio folder APIs, audio file APIs, audio upload sessions, and mixed live task create/update/start.
- Revalidated mixed task video ownership and audio folder/file ownership before task start to prevent API bypass.

## Verification

- `npm.cmd run build`
- `go test ./...`
- `go build ./...`
- Local host health check returned `ok` at `http://127.0.0.1:18081/api/health`.
