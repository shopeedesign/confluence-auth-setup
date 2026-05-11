---
name: confluence-auth-setup
description: Install or update local Confluence read credentials by writing ~/.confluence-credentials for skills like confluence-search and prd-design-brief, with Shopee defaults so users can paste only a token.
---

# Confluence Auth Setup

Use this skill when the user wants one-click Confluence authorization on the local machine so other skills can read internal Confluence pages.

## What this skill does

- Accepts either:
  - a raw Confluence token
  - a single `export CONFLUENCE_TOKEN=...` line
  - a full auth export block
- Defaults to Shopee Confluence values when the user only provides a token:
  - `CONFLUENCE_BASE_URL="https://confluence.shopee.io"`
  - `CONFLUENCE_AUTH_TYPE="Bearer"`
- Writes those values into `~/.confluence-credentials`
- Sets file permission to `600`
- Backs up any existing credentials file before overwrite
- Verifies the file exists and contains the required keys

## Trigger examples

- `帮我授权 Confluence`
- `安装 Confluence 读取权限`
- `一键配置 confluence-search 的凭据`
- `把这段 Confluence Bearer 授权写到本机`

## Input format

The preferred input is a shell-style export block, for example:

```sh
export CONFLUENCE_BASE_URL="https://confluence.example.com"
export CONFLUENCE_AUTH_TYPE="Bearer"
export CONFLUENCE_TOKEN="REDACTED"
```

For Shopee's default setup, the user can also provide only:

```text
OTEyNDUyNjA3ODA3...
```

or:

```sh
export CONFLUENCE_TOKEN="OTEyNDUyNjA3ODA3..."
```

## Workflow

1. Check whether the user provided a raw token, a token export, or a full export block.
2. If the user only provided a token, assume:
   - `CONFLUENCE_BASE_URL="https://confluence.shopee.io"`
   - `CONFLUENCE_AUTH_TYPE="Bearer"`
3. Run `scripts/install_confluence_credentials.sh`, passing the provided content over stdin.
4. If `~/.confluence-credentials` already exists, let the script create a timestamped backup beside it.
5. Verify the file now exists and contains non-empty values for the three required keys.
6. Confirm success to the user without echoing the token. Mask it if you need to mention it.

## Guardrails

- Never print the raw token back to the user.
- Never commit credentials into a repo or save them inside the skill files.
- Only write the local credentials file used for read access.
- If the token is missing, stop and tell the user exactly what is missing.
- If `CONFLUENCE_BASE_URL` or `CONFLUENCE_AUTH_TYPE` is missing but the user only gave a token, fill them with the Shopee defaults instead of stopping.
- If another skill later needs Confluence access, prefer reusing this credentials file rather than asking the user to paste the token again.
