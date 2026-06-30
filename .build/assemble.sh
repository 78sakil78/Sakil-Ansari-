#!/usr/bin/env bash
# usage: assemble.sh <slug> <title> <description> <extra_css_file> <main_file>
set -euo pipefail
slug="$1"; title="$2"; desc="$3"; extra="$4"; main="$5"
B=.build
# base css body (strip the wrapping <style>/</style> lines)
basecss=$(sed '1{/^<style>$/d};${/^<\/style>$/d}' "$B/base.css.html")

# ---- standalone HTML ----
{
  echo '<!DOCTYPE html>'
  echo '<html lang="en">'
  echo '<head>'
  echo '<meta charset="utf-8"/>'
  echo '<meta name="viewport" content="width=device-width, initial-scale=1"/>'
  echo "<title>${title}</title>"
  echo "<meta name=\"description\" content=\"${desc}\"/>"
  echo '<style>'
  printf '%s\n' "$basecss"
  cat "$extra"
  echo '</style>'
  echo '</head>'
  echo '<body>'
  cat "$B/header.html"
  cat "$main"
  cat "$B/footer.html"
  echo '</body>'
  echo '</html>'
} > "${slug}.html"

# ---- paste-ready Custom Liquid ----
{
  echo '{% raw %}'
  echo '<style>'
  printf '%s\n' "$basecss"
  cat "$extra"
  echo '</style>'
  cat "$B/header.html"
  cat "$main"
  cat "$B/footer.html"
  echo '{% endraw %}'
} > "paste/${slug}.liquid"

echo "built ${slug}.html and paste/${slug}.liquid"
