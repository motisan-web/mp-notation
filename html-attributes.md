# タグの選び方・属性・アクセシビリティ・JS との連携

アクセシビリティについて記法に入れるのは、迷わず書けて機械的に検品できる最低限に限る。コントラスト比などはデザインの側の責任として扱う。

## section

- `<section>` がモジュールの最上位の要素なら、そのモジュールクラス（`bl_*`）を付ける。`ly_section` のような共通レイアウトクラスは `<section>` にほぼ使わない。コンテナ目的で共通クラスが必要なら `ly_cont` を使う
- コーポレートサイト・HP では、ページに組み込むときに `<section>` へ `id` を付ける（ページ内リンクの起点になるため）。モジュール単体の HTML には `id` を書かない（値はページごとに決まるため）

```html
<!-- ページに組み込んだ状態 -->
<section id="service" class="bl_service">

<!-- ✕ ly_section を section に使わない -->
<section id="about" class="ly_section ly_section__gray">
```

## 見出し

モジュールは、自分の最上位の見出しを **h2** として書く。ページに置く場所によってレベルが変わるので、組み込むときに調整する。

## 短いテキスト

見出し以外のテキストは、文の体をなしているかどうかでタグを選ぶ。

上から順に当てはめる。

1. 一部だけスタイルが違う（中に `_lv` の span を持つ）→ `p`（文でなくてもよい。span の中に span を入れないため）
2. 文（センテンス）の体をなしている → `p`（段落でなくてもよい）
3. 文より小さい（ラベル・英語表記・コピーライト・商品名など）→ `span`

```html
<!-- 30ml×2 のうち「ml×2」だけスタイルが違う → 文ではないが p -->
<p class="bl_item_btn_txt">
    30<span class="bl_item_btn_txt_lv2">ml×2</span>
</p>
```

見出しの上に乗る英語表記は `span._subTtl` にし、見出しの中に入れず兄弟要素として置く（見出しとして伝わる内容を変えないため）。見た目で上にあるなら DOM でも前に置く。

```html
<span class="bl_service_subTtl">SERVICE</span>
<h2 class="bl_service_ttl">
    事業内容
</h2>
```

見出し・ボタンなど、`div` や `p` を入れられない要素の中で行やかたまりを作るときも `span` を使う（`span` はベーススタイルで `display: block` になっている → [scss.md](scss.md)「前提とするベーススタイル」）。

## 画像

すべての `<img>` に `src` / `alt` / `width` / `height` を書く。

```html
<!-- サイズが未確定の場合 -->
<!-- TODO:img width height設定 -->
<img src="/img/image.jpg" alt="代替テキスト" width="" height="">
```

エージェントがコーディングする場合、画像ファイルがあればサイズを取得して埋め込む（TODO は不要）。

```bash
php -r "list(\$w,\$h)=getimagesize('path/to/image.jpg'); echo \$w.'x'.\$h;"
```

### 装飾の画像・アイコン

**装飾かどうかは、取り除いても意味が伝わるかで判定する。**

- 取り除いても意味が伝わる（飾りの線・背景・見出しの横の飾りのアイコンなど）→ 装飾
  - 画像には `alt=""` と `aria-hidden="true"` の両方を付ける（装飾だと伝え、アクセシビリティツリーから外し、コードを読む人にも意図を示す）
  - img 以外のアイコン（SVG など）にも `aria-hidden="true"` を付ける
- 取り除くと意味が変わる（FAQ の Q / A、手順の番号など、意味を区別するラベル）→ 装飾ではない
  - 画像なら `alt` にそのラベルを書く。テキストなら `aria-hidden` を付けない
  - FAQ の Q / A を隠すと、読み上げで質問と回答の区別が消える

```html
<!-- 装飾 -->
<img src="deco.png" alt="" aria-hidden="true" width="" height="">

<!-- 意味を区別するラベル（装飾ではない） -->
<img class="bl_faq_item_q_icon" src="q-icon.svg" alt="Q" width="12" height="19">
<span class="bl_faq_item_a_icon">A</span>
```

## `un_hide`（見えないが読み上げるテキスト）

視覚的には隠すが DOM には存在し、スクリーンリーダーには読み上げられるテキストに使う。

| 場面 | 説明 |
|---|---|
| 見出しの中身が画像だけ | SEO のシグナルとしてテキストが必要 |
| 画像に焼き込まれたテキスト | 装飾の都合で画像になっているテキストを、DOM の自然な位置に置く |
| 文中のロゴ画像の補足 | 文の流れとして読み上げさせたい |

インライン画像で、画像そのものの説明で足りる場合（単純なアイコン、文中の装飾ロゴ）は `alt` で足りる。

## リンクとボタン

- ページ遷移は `a`。`href` は必須で、空にしない（未確定なら `href="#"` と TODO コメント）
- ページ内の操作（開閉・切り替えなど）は `button type="button"`
- `div` や `span` にクリックの処理を付けない
- `target="_blank"` には `rel="noopener"` を付ける

## 開閉 UI（アコーディオンなど）

- 基本は `details` / `summary`（JS なしで開閉でき、キーボード操作と読み上げにブラウザが対応する）
- 開閉のアニメーションが必要なときだけ、`button` ＋ `aria-expanded` ＋ `aria-controls` ＋ JS を使う。このとき開閉のボタンの `aria-expanded` と、開く要素の `is_open` を必ず同時に切り替える（→ [naming.md](naming.md)「状態（`is_`）」）

## ナビゲーション

1ページに `nav` が2つ以上あるときは、`aria-label` で区別する（例: `aria-label="グローバル"` / `aria-label="フッター"`）。

## JS との連携

JS のコードそのものの書き方は [js.md](js.md)。

### JS がつかむ要素

- JS がつかむ要素には `js_` クラスを付ける
- `js_` にはスタイルを当てない（SCSS に `.js_` を書かない）
- JS は `js_` クラスか data 属性だけをつかむ。`bl_` などのスタイル用クラスをつかまない（見た目のためにクラス名を変えたとき、JS が壊れないように）
- 命名は階層チェーンに合わせる: `js_gallery_scroll > js_gallery_scroll_track`

```html
<div class="bl_gallery_scroll js_gallery_scroll">
    <div class="bl_gallery_scroll_track js_gallery_scroll_track">…</div>
</div>
```

### JS が付け外しするクラス

| 目的 | 付けるクラス | 例 |
|---|---|---|
| スタイルを伴う状態（開閉・選択・現在地など） | `is_`（言葉は [naming.md](naming.md)「状態（`is_`）」の表から選ぶ） | `bl_faq_item is_open` |
| 動きの演出（フェードイン・スライドなど） | `an_` | `an_fadeIn` |

- JS が付け外しするのは `is_` と `an_` だけ。モディファイア（`__`）は HTML を書くときに決めるもので、JS で付け外ししない
- 状態と動きを兼ねるとき（開くときにフェードもする）は両方付ける
- `is_` と一緒に、表にある aria 属性も同時に切り替える。見た目と読み上げの状態を食い違わせないため
- スタイルを伴わない JS の内部の状態（遅延読み込みの途中など）は、クラスにせず data 属性で持つ: `data-lazy="loading"` → `data-lazy="loaded"`。汎用スクリプトはどのモジュールにも付くので、モジュールのクラスに頼らない
- 自前で用意した汎用スクリプトのクラスも MP記法で命名する。外部ライブラリが付けるクラスは対象外

### data 属性

- 名前は HTML の慣習どおりハイフン区切りにする（`data-no-lazy`）。JS の `dataset` がハイフン区切りを前提にキャメルケース（`dataset.noLazy`）へ変換するため。ハイフン禁止はクラス名だけのルール
- 同じ意味をクラスと data 属性の両方で持たない

## モジュールの目印（`data-mp`）

Module Palette のモジュールを元にした要素には、ルート要素に `data-mp` でモジュールの slug を書く（→ [module-format.md](module-format.md)）。

```html
<section class="bl_faq" data-mp="004-faq-icon">
```
