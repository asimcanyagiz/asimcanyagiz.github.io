#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
article="$root/articles/from-ai-capability-to-consumer-habit.html"
article_two="$root/articles/shipping-reliable-ai-features-in-consumer-mobile-apps.html"
article_index="$root/articles/index.html"

test -f "$article_index"
grep -q '<link rel="canonical" href="https://asimcanyagiz.me/articles/">' "$article_index"
grep -q 'From AI Capability to Consumer Habit' "$article_index"
grep -q 'Shipping Reliable AI Features in Consumer Mobile Apps' "$article_index"
grep -q '<loc>https://asimcanyagiz.me/articles/</loc>' "$root/sitemap.xml"

test -f "$article"
grep -q '<link rel="canonical" href="https://asimcanyagiz.me/articles/from-ai-capability-to-consumer-habit.html">' "$article"
grep -q '"@type": "Article"' "$article"
grep -q 'From AI Capability to Consumer Habit' "$article"
grep -q 'articles/from-ai-capability-to-consumer-habit.html' "$root/index.html"
test -f "$root/sitemap.xml"
grep -q 'articles/from-ai-capability-to-consumer-habit.html' "$root/sitemap.xml"

test -f "$article_two"
grep -q '<link rel="canonical" href="https://asimcanyagiz.me/articles/shipping-reliable-ai-features-in-consumer-mobile-apps.html">' "$article_two"
grep -q '"@type": "Article"' "$article_two"
grep -q 'Shipping Reliable AI Features in Consumer Mobile Apps' "$article_two"
grep -q 'articles/shipping-reliable-ai-features-in-consumer-mobile-apps.html' "$root/index.html"
grep -q 'articles/shipping-reliable-ai-features-in-consumer-mobile-apps.html' "$root/sitemap.xml"

grep -q 'id="contact"' "$root/index.html"
grep -q 'action="https://formspree.io/f/mwlkkwnz"' "$root/index.html"
grep -q 'name="name"' "$root/index.html"
grep -q 'name="email"' "$root/index.html"
grep -q 'name="message"' "$root/index.html"
grep -q 'name="_gotcha"' "$root/index.html"
grep -q 'id="form-status"' "$root/index.html"
grep -q 'Your details are used only to reply' "$root/index.html"
grep -q 'location.hash' "$root/assets/js/main.js"
grep -Eq '\.article-author[^}]*color: var\(--ink\)' "$root/assets/css/article.css"
grep -Eq '\.article-author[^}]*display: block' "$root/assets/css/article.css"

if grep -Eqi 'mailto:|meycasim@gmail\.com' "$root/index.html"; then
  echo "direct email address found in public homepage" >&2
  exit 1
fi

# Positive checks: the core public metadata must point at the custom domain.
# Guards against a wrong-but-not-github.io value (e.g. a typo'd .com) that the
# negative guard below would not catch.
grep -q '<meta property="og:url" content="https://asimcanyagiz.me/">' "$root/index.html"
grep -q '<link rel="canonical" href="https://asimcanyagiz.me/">' "$root/index.html"
grep -q 'Sitemap: https://asimcanyagiz.me/sitemap.xml' "$root/robots.txt"

# Migration guard: the site now lives on the custom domain asimcanyagiz.me.
# Fail if the retired github.io domain reappears in any public metadata file.
# Check the known public files explicitly with plain `grep -q` — portable to
# BSD, GNU and busybox grep alike (no --include flag), and it never recurses
# into .git the way `grep -r "$root"` would.
for public_file in \
  "$root/index.html" \
  "$article_index" \
  "$article" \
  "$article_two" \
  "$root/sitemap.xml" \
  "$root/robots.txt"; do
  if grep -q 'asimcanyagiz\.github\.io' "$public_file"; then
    echo "retired github.io domain found in public metadata: $public_file" >&2
    exit 1
  fi
done

if grep -Eqi '297[,\.]?859|294[,\.]?824|282[,\.]?145|revenue|income|salary|huseyinaliyagiz|fatmagul' "$article"; then
  echo "confidential or financial language found in public article" >&2
  exit 1
fi

if grep -Eqi '297[,\.]?859|294[,\.]?824|282[,\.]?145|revenue|income|salary|huseyinaliyagiz|fatmagul|zodya' "$article_two"; then
  echo "confidential, product-specific or financial language found in second public article" >&2
  exit 1
fi

echo "site content checks passed"
