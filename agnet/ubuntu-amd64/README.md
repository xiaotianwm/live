# agnet Deployment Package

This directory contains the Ubuntu `amd64` deployment package for `agnet`.
It includes deploy artifacts and scripts only, not source code.

## Files

- `agnet`: Linux executable
- `app.env.example`: example environment file
- `install.sh`: install and register the systemd service
- `update.sh`: update the binary and restart the service
- `uninstall.sh`: remove the service and install directory
- `start.sh`: start the service
- `stop.sh`: stop the service

## Usage

```bash
cd /path/to/ubuntu-amd64
chmod +x install.sh update.sh uninstall.sh start.sh stop.sh agnet
sudo ./install.sh
```

## Installed Paths

- Service: `live-agnet.service`
- Install dir: `/opt/live/agnet`
- Config: `/opt/live/agnet/app.env`
- Data dir: `/opt/live/agnet/data`

## Logs

```bash
journalctl -u live-agnet.service -f
```

## Notes

- `install.sh` installs `ffmpeg` automatically if it is missing.
- Default listen address example: `0.0.0.0:19180`
- `GET /api/agent/info` is loopback-only by default.
