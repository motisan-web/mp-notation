#!/usr/bin/env bash
# GitHub Pages の元になるファイルを組み立てる（Jekyll にかける前の段階）。
#
#   scripts/build-site.sh [出力先]          タグ（v*）ごとに <出力先>/<タグ>/ を作る
#   scripts/build-site.sh --samples <dir>   <dir>/samples/ のプレビューページだけ作る（手元での確認用）
#
# main はリリース前の書きかけを含むので公開しない。公開するのはタグだけ。
# samples/ の各モジュールは、SCSS をコンパイルして {名前}.css と index.html（プレビュー）を足す。
set -euo pipefail

build_samples() {
    local dir="$1" sample name
    [ -d "$dir/samples" ] || return 0
    for sample in "$dir"/samples/*/; do
        [ -f "$sample/scss-mp.scss" ] || continue
        name="$(basename "$sample")"
        sass --no-source-map --silence-deprecation=slash-div \
            "$sample/scss-mp.scss" "$sample/$name.css"
        {
            cat <<EOF
<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$name | MP記法 サンプル</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="../base.css">
<link rel="stylesheet" href="$name.css">
</head>
<body>
EOF
            cat "$sample/html-structure.html"
            cat <<EOF
</body>
</html>
EOF
        } > "$sample/index.html"
    done
}

if [ "${1:-}" = "--samples" ]; then
    build_samples "${2:?ディレクトリを指定してください}"
    exit 0
fi

out="${1:-_build}"
rm -rf "$out"
mkdir -p "$out"

tags="$(git tag --list 'v*' --sort=-version:refname)"
[ -n "$tags" ] || { echo "タグ（v*）がありません" >&2; exit 1; }
latest="$(printf '%s\n' "$tags" | head -n 1)"

for tag in $tags; do
    mkdir -p "$out/$tag"
    git archive "$tag" | tar -x -C "$out/$tag"
    rm -rf "$out/$tag/.github" "$out/$tag/scripts"
    build_samples "$out/$tag"
done

cat > "$out/_config.yml" <<EOF
title: MP記法
description: HTML + SCSS のコーディング記法
theme: jekyll-theme-primer
plugins:
  - jekyll-relative-links
  - jekyll-readme-index
  - jekyll-titles-from-headings
relative_links:
  enabled: true
  collections: false
EOF

{
    echo "# MP記法"
    echo
    echo "HTML + SCSS のコーディング記法。バージョンごとに読めます。"
    echo
    echo "- 最新: [$latest]($latest/)"
    echo
    echo "## すべてのバージョン"
    echo
    for tag in $tags; do
        echo "- [$tag]($tag/)"
    done
    echo
    echo "ソース: <https://github.com/motisan-web/mp-notation>"
} > "$out/index.md"

echo "built: $out（最新 $latest）"
