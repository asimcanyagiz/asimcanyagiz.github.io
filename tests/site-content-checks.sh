#!/bin/sh
set -eu

# asimcanyagiz.github.io is a NEUTRAL, account-scoped app-support directory
# (Hesap Defans F6): it lists only this account's own iOS apps and their
# privacy / terms / support pages. It must NOT carry the "App Skies founder /
# owner" persona (that lives, by design, at asimcanyagiz.me) and must NOT
# bridge to any other brand: the app legal pages are one path-truncation from
# this root, so a reviewer truncating them must land on nothing cross-brand.

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
index="$root/index.html"

# --- Positive: the neutral directory and its app links exist ---
test -f "$index"
grep -q 'Apps by Asım Can Yağız' "$index"
grep -q 'workr-pages/privacy.html' "$index"
grep -q 'workr-pages/terms.html' "$index"
grep -q 'workr-pages/support.html' "$index"
grep -q 'moneypot-legal/privacy-policy.html' "$index"
grep -q 'moneypot-legal/terms.html' "$index"
test -f "$root/sitemap.xml"
grep -q '<loc>https://asimcanyagiz.github.io/</loc>' "$root/sitemap.xml"
grep -q 'Sitemap: https://asimcanyagiz.github.io/sitemap.xml' "$root/robots.txt"

# --- Negative: the persona blog is gone ---
if [ -d "$root/articles" ]; then
  echo "persona articles/ directory still present" >&2
  exit 1
fi

# --- Negative: no ownership persona anywhere in public files ---
for public_file in "$index" "$root/sitemap.xml" "$root/robots.txt"; do
  if grep -Eqi 'App Skies|majority owner|\bfounder\b|\bdirector\b' "$public_file"; then
    echo "ownership persona language found in $public_file" >&2
    exit 1
  fi
  # cross-brand bridges: the GitHub repo list (github.com/asimcanyagiz) exposed
  # other-brand repos; other account/brand names must never appear here.
  if grep -Eqi 'github.com/asimcanyagiz|huseyin|fatmagul|appskies|habittracker|zodya' "$public_file"; then
    echo "cross-brand reference found in $public_file" >&2
    exit 1
  fi
  # operator personal / login identities must never be public
  if grep -Eqi 'mailto:|meycasim@icloud\.com|meycasim@gmail\.com|asina_yim' "$public_file"; then
    echo "operator personal/login identity found in $public_file" >&2
    exit 1
  fi
done

echo "site content checks passed"
