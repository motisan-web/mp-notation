# サンプル

MP記法で書いたモジュールの例。案件由来ではない、公開用に作ったデザイン。形式は [module-format.md](../module-format.md) に従う。

| サンプル | 内容 | 見どころ |
|---|---|---|
| [feature-card](feature-card/) | 見出しと特長カード3枚とボタン | `_header` と `_subTtl`、`_cardList > _card`、文中の `_lv2`、`_btnWrap`、装飾アイコンの `aria-hidden` |

各サンプルのファイル:

- `html-structure.html` / `scss-mp.scss`: モジュールのソース
- `{名前}.css` と `index.html`（プレビュー）は GitHub Pages の公開時に生成する（リポジトリには置かない）

SCSS は `@use "../../global/" as *;` で、このリポジトリの `global/` の mixin を読む。プレビューには [base.css](base.css)（[scss.md](../scss.md)「前提とするベーススタイル」にあたるもの）を当てる。

手元でプレビューを作るとき（`sass` が必要）は、リポジトリの外にコピーしてから実行する:

```bash
cp -r samples global /tmp/mpn && scripts/build-site.sh --samples /tmp/mpn
```
