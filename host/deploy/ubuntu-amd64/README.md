# host Ubuntu AMD64

This directory contains the Ubuntu `amd64` release package for `host`.

Contents:
- `host`: Linux `amd64` binary
- `dist/`: frontend static assets
- `app.env.example`: environment variable example
- `install.sh`: install and register the systemd service
- `update.sh`: replace binary and frontend assets, then restart the service
- `uninstall.sh`: uninstall the service but keep config and data
- `start.sh`: restart the service
- `stop.sh`: stop the service

Service info:
- service name: `live-host.service`
- install dir: `/opt/live/host`
- config file: `/opt/live/host/app.env`

Health check:
```bash
curl http://127.0.0.1:18081/api/health
```
