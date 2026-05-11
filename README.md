# Confluence 一键授权

用于在本机一键完成 Confluence 读取凭据配置，供 `confluence-search`、`prd-design-brief` 等需要读取公司内部文档的 skill 直接复用。

## 能力说明

- 支持三种输入：纯 token、单行 `export CONFLUENCE_TOKEN=...`、完整 export 授权块
- 如果只提供 token，会自动补全 Shopee Confluence 默认配置
- 自动写入 `~/.confluence-credentials`
- 覆盖前自动备份已有凭据文件
- 自动将文件权限设为 `600`

## 仓库内容

- `SKILL.md`
- `scripts/install_confluence_credentials.sh`

## 输入示例

```sh
export CONFLUENCE_BASE_URL="https://confluence.shopee.io"
export CONFLUENCE_AUTH_TYPE="Bearer"
export CONFLUENCE_TOKEN="REDACTED"
```

或者只贴：

```text
YOUR_CONFLUENCE_TOKEN
```

## 安全说明

- 不会把 token 存进仓库
- 不会把明文 token 回显给用户
- 只会写本地读取所需的凭据文件
