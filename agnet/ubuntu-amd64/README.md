# agnet 部署包

这是 `agnet` 的 Ubuntu `amd64` 部署目录，只包含部署产物和脚本，不包含源码。

## 目录说明

- `agnet`：Linux 可执行文件
- `app.env.example`：环境变量示例
- `install.sh`：一键安装并注册 systemd 服务
- `start.sh`：启动服务
- `stop.sh`：停止服务

## 使用方式

```bash
cd /path/to/ubuntu-amd64
chmod +x install.sh start.sh stop.sh agnet
sudo ./install.sh
```

安装完成后：

- 服务名：`live-agnet.service`
- 安装目录：`/opt/live/agnet`
- 配置文件：`/opt/live/agnet/app.env`
- 数据目录：`/opt/live/agnet/data`
- 日志查看：

```bash
journalctl -u live-agnet.service -f
```

## 说明

- `install.sh` 会在系统缺少 `ffmpeg` 时自动安装
- 默认监听地址示例为 `0.0.0.0:19180`
- `GET /api/agent/info` 默认只允许本机访问
