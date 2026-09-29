# モジュールとして切り出すときの形式

Module Palette に登録するモジュール（と、このリポジトリの samples/）の形式。登録の手順そのものは Module Palette 側の手順書に従う。

## 1つのモジュールに含めるもの

| ファイル | 中身 |
|---|---|
| `html-structure.html` | モジュールの HTML（必須） |
| `html-example.html` | 使用例の HTML（任意） |
| `scss-mp.scss` | モジュールの SCSS（必須）。案件の `scss/module/` に置くファイルと同じもの |
| `images/` | モジュール内で使う画像（任意） |

## HTML

- ルート要素に `data-mp` でモジュールの slug を書く: `<section class="bl_faq" data-mp="004-faq-icon">`
  - 意味は「このモジュールを元にした」。案件で改変したあとも残す
  - モジュールの中に別のモジュール（`el_` など）が入れ子になっている場合は、それぞれのルートに付ける
  - 案件に納品するときは、除去ツールで一括して取り除ける
- `section` に `id` を書かない（ページに組み込むときに付ける → [html-attributes.md](html-attributes.md)「section」）
- 最上位の見出しは h2 で書く（→ [html-attributes.md](html-attributes.md)「見出し」）
- 案件のブランド名・人名はダミーのテキストに置き換える

## SCSS

- 先頭は `@use "../../global/" as *;` の1行（→ [scss.md](scss.md)「`@use`」）。案件にコピーするときは、案件の `global/` の位置に合わせて `@use` のパスだけ調整する
- [scss.md](scss.md)「前提とするベーススタイル」にあるリセット・ベース・`.un_hide` は書かない
- 色の値は、案件ごとに違うので直接書いてよい（色の変数は前提にしない）

## 画像

- モジュールごとに `images/` に置き、ほかのモジュールと共有しない（衝突・削除事故を避け、モジュール単位で完結させるため）
- 使える拡張子: `png` / `jpg` / `jpeg` / `webp` / `svg` / `gif`
- ファイル名: `{用途・名前}-{種類}.{拡張子}`

| 種類 | 意味 |
|---|---|
| `bg` | 背景画像 |
| `icon` | アイコン |
| `img` | 画像全般 |
| `pic` | 写真・情報量の多い画像 |

例: `bnr-bg.png`（バナーの背景）と `logo-icon.svg`（その上に乗るロゴ）

HTML と SCSS の中での画像の参照パスの書き方は、Module Palette 側の仕様に従う（Module Palette がプレビューのときに実際のパスへ置き換える）。案件に移すときは、画像ファイルを案件にコピーし、参照パスを案件の実際のパスに書き換える。
