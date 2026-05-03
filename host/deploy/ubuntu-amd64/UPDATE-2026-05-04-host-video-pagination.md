# Host Update - 2026-05-04 - Video File Pagination

## Updated

- Fixed duplicate first-load video file list requests on the video files page.
- Kept `filePage` as the single normal list-loading trigger.
- Role changes now reset to page 1 or refresh page 1 without adding an extra first-load request.
- Fixed a pagination race when deleting the last item on the last video file page.
- Fixed stale page-state handling when an upload completes after the user has changed pages.

## Verification

- `npm.cmd run build`
- `go build ./...`
- `go test ./...`
- Local host health check returned `ok` at `http://127.0.0.1:18081/api/health`.
