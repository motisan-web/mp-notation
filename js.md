# JS の書き方

モジュールの動き（開閉・切り替え・お知らせなど）を JS で書くときの決まり。HTML 側の決まり（JS がつかむ要素・付け外しするクラス・data 属性）は [html-attributes.md](html-attributes.md)「JS との連携」にある。ここでは JS のコードそのものの書き方を決める。

ビルドの手順を持たない案件でもそのまま貼れることと、同じ書き方で書いた JS をモジュールどうしで使い回せることを目的にする。

## ファイル

- 1つのモジュールの JS は、1つのファイル（Module Palette では `script.js`）にまとめる（→ [module-format.md](module-format.md)）
- HTML のあとで読む（`</body>` の直前に置くか `defer` を付ける）。要素がそろってから動き出すため
- ビルドしない前提で、今のブラウザがそのまま読める書き方にする（`const` / `let`、アロー関数、テンプレート文字列など）。`import` / `export` は使わない
- 外部のライブラリは、できるだけ使わない。使うときは、次のようにする
  - 読み込む URL を、モジュールの情報の外部のスクリプトの一覧に書く（Module Palette では `module.json` の `js_libs`）。https で、バージョンを固定した URL にし、読み込む順に並べる。何に使うかは注意に書く
  - 置く側は、モジュールの JS より先に読むとは限らない（ページを早く出すために `async` で読むことがある）。ライブラリを使う処理は、ライブラリがあるか（`window.hljs` など）を確かめてから動かし、まだなければ `window` の `load` まで待つ
  - ライブラリがないときも、モジュールのほかの動きは止めない（コードの色分けなら、色が付かないだけにする）

## 1つの機能を1つの即時関数にする

- 1つの機能を `(() => { … })();` で包み、グローバル変数を作らない（ほかの JS と名前がぶつからないように）
- 先頭に、何をする機能かを日本語のコメントで書く
- 要素がなければ何もしないで終わる（どのページで読んでも止まらないように）

```js
// よくある質問: 質問を押すと答えを開いて閉じる
(() => {
    for (const faq of document.querySelectorAll('.js_faq')) {
        for (const btn of faq.querySelectorAll('.js_faq_item_btn')) {
            btn.addEventListener('click', () => {
                const item = btn.closest('.js_faq_item');
                const open = !item.classList.contains('is_open');
                item.classList.toggle('is_open', open);
                btn.setAttribute('aria-expanded', String(open));
            });
        }
    }
})();
```

## 何個あっても動くようにする

- モジュールのルートの `js_` クラスを `querySelectorAll` で全部探し、1つずつ準備する。`querySelector` で最初の1つだけを相手にしない（同じモジュールを1ページに2つ置いたとき、2つめが動かなくなるため）
- ルートの中の要素は、`document` からではなく、そのルートから探す（ほかのモジュールの要素をつかまないように）

## 要素のつかみ方

- [html-attributes.md](html-attributes.md)「JS がつかむ要素」のとおり、`js_` クラスか data 属性だけでつかむ。`bl_` などのスタイル用クラスでつかまない
- `js_` クラスの名前は、スタイル用のクラスと同じ階層チェーンにする（`bl_faq_item_btn` → `js_faq_item_btn`。プレフィックスの後ろは同じ）

## 見た目の変え方

- 状態は `is_`、動きの演出は `an_` を付け外しして、見た目は SCSS に任せる。`element.style` で色や表示・非表示を直接変えない（見た目の正本を SCSS の1か所にするため）
- `is_` と一緒に、[naming.md](naming.md)「状態（`is_`）」の表の aria 属性も同時に切り替える
- 測った値（高さ・幅など）を見た目に渡すときだけ、CSS のカスタムプロパティを使う: `el.style.setProperty('--faq-body-height', h + 'px')`。値の使い方は SCSS に書く
- スタイルを伴わない内部の状態は data 属性で持つ（`data-lazy="loading"`）
- `an_` の付け直し（続けてもう一度動かす）は、外してから `offsetWidth` を読み、もう一度付ける

## イベント

- `addEventListener` で付ける。HTML に `onclick` などの属性を書かない
- 押せるものは `button`（ページ内の操作）か `a`（移動）にする。`div` や `span` にクリックを付けない（→ [html-attributes.md](html-attributes.md)「リンクとボタン」）
- キーボードでも同じことができるようにする（`button` を使えば Enter と Space は自動で効く。Esc で閉じるものは `keydown` を足す）

## 動きを減らす設定

- JS で動かすもの（スクロール・自動で切り替わるスライドなど）は、`matchMedia('(prefers-reduced-motion: reduce)')` を見て、動きを減らす設定のときは動かさないか、すぐ終える
- CSS で動かすもの（`an_` のアニメーション）は SCSS 側で同じ設定を見る

## ブラウザに覚えるもの

- `localStorage` のキーは `案件名.名前` にする（`mysite.faqOpen`）。同じドメインのほかの案件とぶつからないように
- 読み書きは `try` で包む（使えない環境〔プライベートブラウズなど〕で止まらないように）。読めなければ既定の状態で動かす

## ほかの JS から呼ばれる機能

ほかの JS から呼ぶ機能（お知らせを出す、など）は、モジュールのルートクラスの名前で `window` に1つだけ出す。

```js
// お知らせ: 操作の結果を画面の右下に少しだけ出す。ほかの JS から window.bl_toast.show('コピーしました') で呼ぶ
(() => {
    let el = null;
    let timer = 0;
    window.bl_toast = {
        show(message) {
            // …
        },
    };
})();
```

- 名前はルートクラスと同じにする（モジュールの数だけ名前があり、ぶつからないため）
- 呼ぶ側は、モジュールの JS がないページでも止まらないように `window.bl_toast?.show('…')` と書く
- 出すのは、ほかから呼ぶ必要のあるものだけにする

## コメント

- SCSS と同じく日本語で書く。何をするかより、なぜそうするか（ブラウザの癖・順番の理由など）を書く
