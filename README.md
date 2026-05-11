# Confluence Auth Setup

One-click local Confluence credential setup for Codex skills that need read access, such as `confluence-search` and `prd-design-brief`.

## What it does

- Accepts a raw token, a single `export CONFLUENCE_TOKEN=...` line, or a full export block
- Defaults to Shopee Confluence values when only a token is provided
- Writes `~/.confluence-credentials`
- Backs up any existing credentials file
- Sets file permission to `600`

## Installed files

- `SKILL.md`
- `scripts/install_confluence_credentials.sh`

## Example input

```sh
export CONFLUENCE_BASE_URL="https://confluence.shopee.io"
export CONFLUENCE_AUTH_TYPE="Bearer"
export CONFLUENCE_TOKEN="REDACTED"
```

Or just:

```text
YOUR_CONFLUENCE_TOKEN
```

## Safety

- Never stores the token in the repo
- Never prints the raw token back to the user
- Only writes the local credentials file used for read access
