# SCSS

## ディレクトリ構成

```
scss/
├── style-{ページ名}.scss   ← エントリーポイント（_ なし = コンパイル対象）
├── global/                 ← 変数・mixin・共通スタイル
│   ├── _index.scss         @forward で global 全体をまとめるハブ
│   ├── _breakpoint.scss    ブレークポイント定義 + mq() mixin
│   ├── _color.scss         CSS変数による色の管理
│   ├── _font.scss          フォントファミリーの変数
│   ├── _base.scss          ベーススタイル
│   ├── _ly.scss            レイアウトクラス（.ly_*）
│   ├── _un.scss            ユーティリティクラス（.un_hide 系）
│   ├── _hp.scss            ヘルパークラス（.hp_*）
│   ├── _an.scss            アニメーションクラス（.an_*）
│   ├── _lib.scss           外部ライブラリの CSS の切り抜き
│   ├── _mixins.scss        mixin・placeholder 集
│   └── _reset.css          リセット CSS
├── module/                 ← モジュールごとのサブディレクトリ（1モジュール1ファイル）
│   └── bl_header/
│       └── _header.scss
└── page/                   ← ページごとのサブディレクトリ
    └── top/
```

エントリーポイントの命名: `style-{ページ名}.scss` → `css/style-{ページ名}.css`

### モジュールファイルの命名

| パターン | ファイル名 | 用途 |
|---|---|---|
| 汎用・複数ページ共通 | `_header.scss` | どのページでも使える |
| ページ固有 | `_header-index2.scss` | index2 ページ専用 |
| デザインのバリアント | `_header-type2.scss` | 見た目が違うバージョン |
| 任意の区分 | `_header-mobile.scss` | 任意の区分名 |

ファイル名はクラス名ではないので、ハイフンを使ってよい。

## 前提とするベーススタイル

次のものは、案件に必ず存在する前提のスタイル。モジュールの SCSS には書かない。

| 種類 | 内容 | ファイル |
|---|---|---|
| リセット | destyle.css 相当 | `_reset.css` |
| ベース | `span { display: block; }` / `img { width: 100%; height: auto; }` / `box-sizing: border-box` / `body` の `line-height: 1.75`・`font-size: 14px` など | `_base.scss` |
| ユーティリティ | `.un_hide` | `_un.scss` |

- 色の変数（`--color-font-base` など）は案件ごとに値が違うので、前提に含めない
- `span` が block になっているのは、見出しやボタンの中で行・かたまりを作るため、装飾用の箱にするため、親を flex にして改行させないかたまりにするため

### フォントファミリーの変数

`_font.scss` の変数は、指定がなければ次をデフォルトにする。

| 変数 | デフォルト値 |
|---|---|
| `--font-family-base` | `'Noto Sans JP', sans-serif` |
| `--font-family-serif` | `'Noto Serif JP', serif`（日本語表示のため JP 版） |

## `@use`

モジュールファイルの先頭は1行だけ。

```scss
@use "../../global/" as *;
```

`as *` で、mixin・変数・関数をプレフィックスなしで呼べる。

```scss
// ✕ 2行に分けない
@use "../../global/" as g;
@use '../../global/mixins' as *;
```

## ネスト

**`&` でクラス名を作る書き方は禁止。** クラスはフラットに並べる。HTML から SCSS を逆引き（grep）することが多く、`&` で作ったクラス名は検索に引っかからないため。

```scss
// ○ フラット
.bl_card { display: flex; }
.bl_card_header { padding: 16px; }
.bl_card_header_ttl { @include f(18px, 700, 1.4); }

// ✕ & でクラス名を作らない
.bl_card {
    &_header { … }
}
```

ネストしてよいのは、クラス名を作らない疑似クラス・疑似要素だけ。

```scss
.bl_card_link {
    &:hover { opacity: 0.7; }
    &:focus-visible { outline: 2px solid currentColor; }
    &::before { content: ""; }
}
```

**子孫セレクタで要素をつかまない。** `.bl_x_txt span { … }` のように、クラスのない要素へ親クラスからスタイルを当てない（HTML から逆引きできず、詳細度も上がるため）。スタイルを当てる要素にはクラスを付ける（→ [naming.md](naming.md)「`_lv`」）。

**`js_` にスタイルを当てない**（→ [html-attributes.md](html-attributes.md)「JS との連携」）。

## span の display

`span` はベーススタイルで block になっているので、文中に置く `_lv` の span（前後にテキストがある）には、`display: inline` か `inline-block` を必ず指定する。指定しないと、その span の前後で改行される。

```scss
.bl_campaign_txt_lv2 {
    display: inline;
    font-weight: 700;
}
```

行やかたまりとして使う span（見出しの2行目など）は block のままでよい。

文中に置く `_lv` の小さな画像には `width` を指定する（ベーススタイルの `img { width: 100%; }` のままだと、親の幅いっぱいに広がるため）。

## mixin の呼び方

| 種類 | ルール | 例 |
|---|---|---|
| font 系 | 短縮版を使う | `@include f(16px, 700, 1.4);` |
| それ以外 | フルネームを使う | `@include flex-between;` |

```scss
// ○
@include flex-between;
@include inner(375px, 20px);
@include mq('tab') { … }
@include f(16px, 400, 1.5, 0em, var(--color-font-dark), var(--font-family-base));

// ✕
@include fx-btw;
@include font(16px, 400, 1.5);
```

`f()` の引数の順: `($size, $weight, $line-height, $spacing, $color, $family)`

`f()` からあふれて別途プロパティを書いている箇所は、少し複雑なスタイルのサイン。

## メディアクエリ

SP ファースト（→ [responsive.md](responsive.md)）。`@include mq()` はクラスの中に書く。

- 空のメディアクエリのブロックは、ツールが自動生成したものなら残してよい（コーダーは読み飛ばす）
- **同じクラスを2か所に書かない。** 1クラスにつき1か所にまとめる

```scss
// ✕
.bl_header_nav_item_link { @include f(16px, 400, 1.5); }
// …（間に別のクラス）…
.bl_header_nav_item_link { @include mq('tab') { … } }

// ○
.bl_header_nav_item_link {
    @include f(16px, 400, 1.5);
    @include mq('tab') { … }
    @include mq('pc') { … }
}
```

## 余白

- **margin**: 余白が必要な要素自身に `margin-top` を付ける（上方向の余白は自分が持つ）
- **padding**: 背景色がつく可能性がある箇所は padding で余白を取る（margin は背景色を引き継がないため）
- `bl_〇〇` の最上位の要素が背景色を担当する

## フォーカス

`outline` を消すときは、`:focus-visible` で代わりのスタイルを必ず付ける。

## アニメーション

`an_` のアニメーションは、`prefers-reduced-motion: reduce` のときに止めるか弱める。

```scss
.an_fadeIn {
    transition: opacity 0.4s;
    @media (prefers-reduced-motion: reduce) {
        transition: none;
    }
}
```

## 空行

| 場面 | 空行 |
|---|---|
| クラスとクラスの間 | 1行 |
| クラス内のプロパティと `@include mq()` の間 | なし |
| コメントの前 | 1行（直前にすでに空行があればそのまま） |
| 空行の最大 | 1行（2行以上にしない） |

## コメント

次のクラスは、内容が分かる場合に **SCSS 側だけ**、直前にコメントを入れる。

| 対象 | コメントの内容 |
|---|---|
| `_ttl` で終わるクラス | 見出しのテキスト |
| `_txt` で終わるクラス | テキストの内容 |
| `_list` で終わるクラス | 何のリストか |

```scss
// 見出し「サービス一覧」
.bl_service_ttl {
    @include f(24px, 700, 1.4);
}

// ナビゲーションのリンクのリスト
.bl_header_nav_list {
    display: flex;
}
```

内容が不明・汎用的すぎる場合は書かなくてよい。HTML には書かない（→ [html-format.md](html-format.md)「コメント」）。
