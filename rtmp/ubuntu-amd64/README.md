# rtmp Ubuntu AMD64

这个目录包含 `rtmp` 的 Ubuntu `amd64` 发布包。

内容：
- `rtmp`: Linux `amd64` 二进制
- `app.env.example`: 环境变量示例
- `install.sh`: 安装并注册 systemd 服务
- `update.sh`: 替换二进制并重启服务
- `uninstall.sh`: 卸载服务和安装目录
- `start.sh`: 启动服务
- `stop.sh`: 停止服务

使用方式：

```bash
cd /path/to/ubuntu-amd64
chmod +x install.sh update.sh uninstall.sh start.sh stop.sh rtmp
sudo ./install.sh
```

服务信息：
- 服务名：`live-rtmp.service`
- 安装目录：`/opt/live/rtmp`
- 配置文件：`/opt/live/rtmp/app.env`

日志查看：

```bash
journalctl -u live-rtmp.service -f
```
