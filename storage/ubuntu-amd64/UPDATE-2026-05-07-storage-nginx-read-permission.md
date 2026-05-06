# Storage Update 2026-05-07

## Updated

- After multipart upload completion, final object files are now chmodded to `0644`.
- This allows nginx static `/objects/` reads to access newly uploaded files without manual `chmod`.

## Notes

- Existing files uploaded before this update may still need a one-time permission repair:

```bash
find /opt/live/storage/data/objects -type f -exec chmod 644 {} \;
```
