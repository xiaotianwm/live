# Storage Service Update - 2026-05-06

## 新增

- 新增独立 `storage` 服务，用于自建本地磁盘对象存储。
- 支持创建上传会话、预分配目标大小、按 offset 写入分片、完成后生成单个完整文件。
- 支持公开 `GET/HEAD /objects/{objectKey}` 读取，兼容 HTTP Range，方便 ffmpeg 读取。
- 管理接口统一使用 `X-API-Key` 鉴权。
- 提供 Ubuntu amd64 systemd 部署产物和在线安装/更新/卸载脚本。

## 修复

- 分片上传改为流式写入，避免大分片整体进入内存。
- 重复上传已完成分片时返回已有分片结果，适配客户端重试。
- complete/abort 增加忙状态保护，避免并发写入、完成、取消互相打断。
- abort 先删除临时文件再移除会话，降低 Windows 文件占用导致孤儿文件的风险。

## 验证

- `go test ./...` 通过。
- `go build ./...` 通过。
- 已验证乱序分片、重复分片、complete 后单文件落盘。
