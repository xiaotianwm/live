# 2026-05-04 Host 更新：数据库迁移到 Neon

## 更新内容

- 将当前阿里云 PostgreSQL 中的 Host 业务数据同步到 Neon PostgreSQL。
- Host 本地运行环境已切换为 Neon 数据库并完成基本验证。
- 发布产物仍然不包含任何数据库连接信息、密码或 DSN。
- 服务器升级后需要在 `/opt/live/host/app.env` 中配置 Neon PostgreSQL 连接信息。

## 数据同步结果

- `host_store_meta`: 1
- `resource_groups`: 2
- `oss_services`: 2
- `agent_nodes`: 1
- `rtmp_services`: 1
- `users`: 5
- `sessions`: 151
- `audio_folders`: 11
- `files`: 2265
- `publish_services`: 11
- `live_tasks`: 9
- `live_task_logs`: 81

## 验证结果

- 本地 Host 使用 Neon 数据库启动成功。
- `/api/health` 返回 `ok`。
- `test` 用户登录成功。
- `test` 用户任务列表读取成功，当前任务总数为 `6`。

## 注意事项

- 旧阿里云 PostgreSQL 数据库未删除，可作为回退来源。
- `host` 需要 PostgreSQL，`agnet` 和 `rtmp` 不需要数据库。
- Neon 连接信息应只写入运行环境配置文件，不写入 GitHub 产物。
