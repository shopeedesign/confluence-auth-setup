#!/bin/sh
set -eu

target="${HOME}/.confluence-credentials"
tmp_input="$(mktemp)"
tmp_output="$(mktemp)"
cleanup() {
  rm -f "$tmp_input" "$tmp_output"
}
trap cleanup EXIT

cat > "$tmp_input"

get_line() {
  key="$1"
  line="$(grep -E "^export ${key}=" "$tmp_input" | tail -n 1 || true)"
  printf '%s\n' "$line"
}

trimmed_input="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' "$tmp_input")"

base_url_line="$(get_line CONFLUENCE_BASE_URL)"
auth_type_line="$(get_line CONFLUENCE_AUTH_TYPE)"
token_line="$(get_line CONFLUENCE_TOKEN)"

if [ -z "$token_line" ]; then
  raw_token="$(printf '%s\n' "$trimmed_input" | awk 'NF { print; exit }')"
  if [ -n "$raw_token" ] && ! printf '%s\n' "$raw_token" | grep -q '^export '; then
    token_line="export CONFLUENCE_TOKEN=\"$raw_token\""
  fi
fi

if [ -z "$token_line" ]; then
  echo "Missing required token: CONFLUENCE_TOKEN" >&2
  exit 1
fi

if [ -z "$base_url_line" ]; then
  base_url_line='export CONFLUENCE_BASE_URL="https://confluence.shopee.io"'
fi

if [ -z "$auth_type_line" ]; then
  auth_type_line='export CONFLUENCE_AUTH_TYPE="Bearer"'
fi

printf '%s\n%s\n%s\n' \
  "$base_url_line" \
  "$auth_type_line" \
  "$token_line" > "$tmp_output"

if [ -f "$target" ]; then
  backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
  cp "$target" "$backup"
fi

mv "$tmp_output" "$target"
chmod 600 "$target"

for key in CONFLUENCE_BASE_URL CONFLUENCE_AUTH_TYPE CONFLUENCE_TOKEN; do
  if ! grep -q "^export ${key}=" "$target"; then
    echo "Verification failed for ${key}" >&2
    exit 1
  fi
done

echo "Installed Confluence credentials to $target"
