# 2026-05-04 Host 更新：混流任务启动优化

## 更新内容

- 优化 `video_random_audio_to_rtmp` 混流任务启动链路。
- Host 启动文件推流/混流任务时，只读取一次资源组和 OSS 配置，并在本次启动调用内构建临时 OSS 索引。
- 音频目录内多个音频文件解析 URL 时复用同一份 OSS 索引，不再每个音频文件重复读取资源组配置。
- 保留多 OSS 支持，文件 URL 匹配顺序为：
  - `resourceGroupId + storageServiceId`
  - `storageServiceId`
  - `storageService` 名称
- `pull_to_rtmp` 拉流转推任务不会额外读取 OSS 配置。
- 新增多 OSS 混流测试，覆盖同一音频目录中不同 OSS 文件的 URL 解析，并验证一次启动中 `ListResourceGroups()` 只调用一次。

## 验证结果

- `red-04-新加坡-美甲` 任务音频目录包含 `799` 个音频文件。
- 优化前 `resolveAudioURLs` 耗时约 `2分50秒`。
- 优化后代码级测量 `resolveAudioURLs` 耗时约 `315ms`。
- 本地完整 API 启动耗时约 `6-7s`。
- 代码级拆分显示 Host 侧文件和音频 URL 解析已经不是主要瓶颈，剩余耗时主要来自调用远端 agnet、PG 状态写入和本地到服务器网络。

## 测试记录

- `go test ./internal/livetask` 通过。
- `go test ./...` 通过。
- `go build ./...` 通过。
- 本地最新版 Host 已启动并通过健康检查：`/api/health` 返回 `ok`。

## 影响范围

- 只更新 `host`。
- 不修改 `agnet`。
- 不修改 `rtmp`。
- 不引入全局 OSS 缓存。
- 不改变 PostgreSQL 作为 Host 业务数据源的规则。
