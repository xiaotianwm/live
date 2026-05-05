# Host Update 2026-05-06 R2 Cache

## Updated

- Cloudflare R2 object access URLs now prefer custom domain before internal/public endpoints.
- Live task dispatch now sends R2 video and audio URLs through the custom domain when configured.
- R2 direct uploads now write `Cache-Control: public, max-age=31536000, immutable`.
- R2 multipart upload create/complete paths now include the same cache control metadata.
- Browser direct upload now sends signed upload headers returned by host.
- Direct upload CORS validation now requires `Cache-Control` when R2 upload headers need it.

## Verified

- `npm.cmd run build`
- `go test ./...`
- `go build ./...`
- Local host `/api/health`
- Real R2 upload verified with `Cache-Control` response header.
- Real R2 range read verified `cf-cache-status: MISS` then `HIT`.
