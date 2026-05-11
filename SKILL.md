---
name: confluence-auth-setup
description: 通过写入 ~/.confluence-credentials 一键安装或更新本机 Confluence 读取凭据，供 confluence-search、prd-design-brief 等 skill 复用；支持只粘贴 token，并自动补全 Shopee 默认配置。
---

# Confluence 一键授权

当用户希望在本机一键完成 Confluence 授权，让其他 skill 能直接读取公司内部 Confluence 文档时，使用这个 skill。

## 这个 skill 会做什么

- 接受以下任一输入：
  - 纯 Confluence token
  - 单行 `export CONFLUENCE_TOKEN=...`
  - 完整 export 授权块
- 如果用户只提供 token，自动补全 Shopee Confluence 默认配置：
  - `CONFLUENCE_BASE_URL="https://confluence.shopee.io"`
  - `CONFLUENCE_AUTH_TYPE="Bearer"`
- 将配置写入 `~/.confluence-credentials`
- 自动把文件权限设为 `600`
- 覆盖前先备份已有凭据文件
- 写入后校验必需字段是否存在

## 触发示例

- `帮我授权 Confluence`
- `安装 Confluence 读取权限`
- `一键配置 confluence-search 的凭据`
- `把这段 Confluence Bearer 授权写到本机`

## 输入格式

推荐输入是 shell 风格的 export 授权块，例如：

```sh
export CONFLUENCE_BASE_URL="https://confluence.example.com"
export CONFLUENCE_AUTH_TYPE="Bearer"
export CONFLUENCE_TOKEN="REDACTED"
```

如果是 Shopee 的默认配置，用户也可以只提供：

```text
OTEyNDUyNjA3ODA3...
```

或者：

```sh
export CONFLUENCE_TOKEN="OTEyNDUyNjA3ODA3..."
```

## 执行流程

1. 判断用户提供的是纯 token、单行 token export，还是完整 export 授权块。
2. 如果用户只提供了 token，则默认补全：
   - `CONFLUENCE_BASE_URL="https://confluence.shopee.io"`
   - `CONFLUENCE_AUTH_TYPE="Bearer"`
3. 执行 `scripts/install_confluence_credentials.sh`，通过 stdin 传入用户提供的内容。
4. 如果 `~/.confluence-credentials` 已存在，让脚本先在旁边生成带时间戳的备份。
5. 校验写入后的文件已存在，并且三项必需配置都非空。
6. 向用户确认成功或失败，但不要回显明文 token；如必须提及，只能脱敏展示。

## 护栏

- 永远不要把明文 token 回显给用户。
- 永远不要把凭据提交进仓库，也不要把 token 写进 skill 文件本身。
- 只允许写本地读取所需的凭据文件。
- 如果缺的是 token，必须明确告诉用户缺少哪一项，不要继续执行。
- 如果缺的是 `CONFLUENCE_BASE_URL` 或 `CONFLUENCE_AUTH_TYPE`，且用户只给了 token，则自动补 Shopee 默认值，不要中断。
- 如果后续其他 skill 也需要 Confluence 访问能力，优先复用这份本地凭据，不要反复让用户重新粘贴 token。
