#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
article="$root/articles/from-ai-capability-to-consumer-habit.html"

test -f "$article"
grep -q '<link rel="canonical" href="https://asimcanyagiz.me/articles/from-ai-capability-to-consumer-habit.html">' "$article"
grep -q '"@type": "Article"' "$article"
grep -q 'From AI Capability to Consumer Habit' "$article"
grep -q 'articles/from-ai-capability-to-consumer-habit.html' "$root/index.html"
test -f "$root/sitemap.xml"
grep -q 'articles/from-ai-capability-to-consumer-habit.html' "$root/sitemap.xml"

grep -q 'id="contact"' "$root/index.html"
grep -q 'action="https://formspree.io/f/mwlkkwnz"' "$root/index.html"
grep -q 'name="name"' "$root/index.html"
grep -q 'name="email"' "$root/index.html"
grep -q 'name="message"' "$root/index.html"
grep -q 'name="_gotcha"' "$root/index.html"
grep -q 'id="form-status"' "$root/index.html"
grep -q 'Your details are used only to reply' "$root/index.html"
grep -q 'location.hash' "$root/assets/js/main.js"

if grep -Eqi 'mailto:|meycasim@gmail\.com' "$root/index.html"; then
  echo "direct email address found in public homepage" >&2
  exit 1
fi

if grep -Eqi '297[,\.]?859|294[,\.]?824|282[,\.]?145|revenue|income|salary|huseyinaliyagiz|fatmagul' "$article"; then
  echo "confidential or financial language found in public article" >&2
  exit 1
fi

echo "site content checks passed"
