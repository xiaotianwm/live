# rtmp Ubuntu AMD64

This directory contains the Ubuntu `amd64` deployment package for `rtmp`.

Contents:

- `rtmp`: Linux `amd64` binary
- `app.env.example`: example environment file
- `install.sh`: install and register the systemd service
- `update.sh`: replace the binary and restart the service
- `uninstall.sh`: remove the service and install directory
- `start.sh`: start the service
- `stop.sh`: stop the service

Usage:

```bash
cd /path/to/ubuntu-amd64
chmod +x install.sh update.sh uninstall.sh start.sh stop.sh rtmp
sudo ./install.sh
```

Service details:

- Service: `live-rtmp.service`
- Install dir: `/opt/live/rtmp`
- Config: `/opt/live/rtmp/app.env`

Logs:

```bash
journalctl -u live-rtmp.service -f
```
