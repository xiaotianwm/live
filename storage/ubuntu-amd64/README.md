# storage ubuntu-amd64 deploy

This directory contains the Ubuntu amd64 deployment artifact for the independent `storage` service.

## Files

- `storage`: service binary.
- `storage.sha256`: binary checksum.
- `app.env.example`: safe default environment file without secrets.
- `install.sh`: installs `live-storage.service` into `/opt/live/storage`.
- `update.sh`: updates the binary and systemd unit without overwriting existing `app.env` or deleting `data`.
- `uninstall.sh`: removes the systemd unit and binary, preserving `/opt/live/storage/data`.
- `start.sh` / `stop.sh`: systemd helpers.

## Install

```bash
sudo bash install.sh
```

The first start generates the API key at:

```text
/opt/live/storage/data/api_key
```

Health check:

```bash
curl -H "X-API-Key: $(cat /opt/live/storage/data/api_key)" http://127.0.0.1:19280/api/health
```

## Data Safety

Install and update keep `/opt/live/storage/data`.
Uninstall removes only the service unit and binary, and keeps `/opt/live/storage/data` and `/opt/live/storage/app.env`.
