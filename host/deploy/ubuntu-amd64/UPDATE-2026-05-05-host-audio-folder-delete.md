# Host Update 2026-05-05

## Updated

- Audio folders now block deletion with a structured conflict response when they still contain audio files or are referenced by live tasks.
- Added a "clear files" action for the selected audio folder.
- Clearing an audio folder now checks live task references before deleting files.
- Audio folder reference checks cover both folder ID references and legacy direct audio file references.
- OSS object cleanup for folder clearing now uses S3 multi-object delete first, with single-object delete fallback when unsupported.

## Verified

- `npm.cmd run build`
- `go test ./...`
- `go build ./...`

