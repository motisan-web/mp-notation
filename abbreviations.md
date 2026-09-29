# 省略語と禁止語

## 省略の方針

- 省略するなら3〜4文字を目安にする（例: `thum` / `btm` / `info`）
- 省略によって直感的に読めなくなるなら、フルスペルを使う
- 表にない1〜2文字の省略はしない（何の語か判別できなくなるため）。表にある `kv` / `bg` / `sm` などは使える
- 表にない語は、フルスペルをキャメルケースで使う。新しく省略したい語が出てきたら、この表に追加してから使う

## レイアウト

| 元の語 | MP記法 | 備考 |
|---|---|---|
| container | `cont` | |
| wrapper | `wrap` | |
| inner | `inner` | |
| key visual | `kv` | |
| header / footer / main / section / article / aside / nav | そのまま | |
| outer | **使用禁止** | 使う場面が不明確 |
| content | **使用禁止** | `cont` と混同するため |

## UI要素

| 元の語 | MP記法 | 備考 |
|---|---|---|
| button | `btn` | |
| thumbnail | `thum` | |
| notification | `notif` | 例外的に5文字 |
| callout | `callout` | `call` にしないのは tel（電話）と混同するため |
| tip / toast / quote | そのまま | |
| link / list / item / menu | そのまま | |
| dropdown / modal / dialog / popup / tooltip | そのまま | |
| accordion / tab / panel / card / badge / alert | そのまま | |

## テキスト・コンテンツ

| 元の語 | MP記法 |
|---|---|
| title | `ttl` |
| text | `txt` |
| subtitle | `subTtl` |
| paragraph | `para` |
| caption | `cap` |
| information | `info` |
| message | `msg` |
| error | `err` |
| label / summary / excerpt / group / note / copyright | そのまま |

- description（説明文）は省略形を作らず `txt` を使う（説明文と本文の使い分けで判断が割れるため）
- heading（見出しのまとまり）は `head` にせず `header` を使う
- `copy` は単体で使わない（コピーライトは `copyright`。キャッチコピーと紛らわしいため）

## フォーム

form / input / textarea / select / option / checkbox / radio / field / group / submit / reset / search — すべてそのまま

## メディア

| 元の語 | MP記法 |
|---|---|
| image | `img` |
| photo（写真） | `pic` |
| thumbnail | `thum` |
| background | `bg` |
| icon / avatar / gallery / video / audio / media | そのまま |

## 状態・属性

active / inactive / disabled / selected / checked / current / hover / focus / loading / open / close / hide / success / error / warning / info / valid / invalid — すべてそのまま（モディファイアとして使う）

## サイズ・方向

| 元の語 | MP記法 |
|---|---|
| bottom | `btm` |
| column | `col` |
| row | `row` |
| extra small / small / medium / large / extra large | `xs` / `sm` / `md` / `lg` / `xl` |
| full / left / right / top / center / prev / next / up / down / bold | そのまま |

## 使用禁止の語

| 語 | 代わり | 理由 |
|---|---|---|
| `content` | `cont` | `cont` と混同する |
| `outer` | — | 使う場面が不明確 |
| `emphasis` / `emp` | `bold` など、見た目の違いは `_lv` で | 非推奨の略語 |

## 避ける命名

- **曖昧な名前**: `box`（必要な場合だけ許容）
- **見た目に依存した名前**: `red` / `big` などをベースクラスに使わない（モディファイアとしてはよい）
- **過度な略語**: 直感的に読めなくなるほどの省略

