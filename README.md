# MP記法

HTML + SCSS のコーディング記法。クラスの付け方、HTML の構造パターン、SCSS の書き方を定める。

- 読み手: コーディングするエージェント（Claude 等）と人間
- バージョン: git のタグで管理する（このファイルを読んでいるタグがそのバージョン）。変更点は [CHANGELOG.md](CHANGELOG.md)
- Web で読む: https://motisan-web.github.io/mp-notation/ （タグごとの URL。例: `/mp-notation/v2.1/`）
- ライセンス: ドキュメントは CC BY 4.0、コード（samples/・global/・scripts/）は MIT（[LICENSE](LICENSE)）

## 作業ごとに読むファイル

| 作業 | 読むファイル |
|---|---|
| 新しくコーディングする | [naming.md](naming.md) → [patterns.md](patterns.md) → [abbreviations.md](abbreviations.md) → [html-format.md](html-format.md) → [html-attributes.md](html-attributes.md) → [responsive.md](responsive.md) → [scss.md](scss.md) |
| 既存のモジュールを土台に改変する | 上に加えて [naming.md](naming.md) の「ルートクラスの付け替え」 |
| Module Palette にモジュールとして登録する | 上に加えて [module-format.md](module-format.md) |
| 書かれたコードを検品する | [checklist.md](checklist.md) |
| 記法の考え方を知る | [philosophy.md](philosophy.md) |
| 決まっていないこと・次の版の予定 | [open-questions.md](open-questions.md) |

判断に迷う箇所があれば、推測で埋めずに [open-questions.md](open-questions.md) に載っているか確認する。載っていなければ、それ自体が記法の穴なので報告する。

## バージョンの付け方

基準は「既存の準拠コードが違反になるかどうか」。

| 種類 | 内容 |
|---|---|
| MAJOR（例: 3.0） | それまで準拠していたコードが違反になる変更。移行ガイドを付ける |
| MINOR（例: 2.1） | 決まっていなかった箇所を埋める・運用の多数派を明文化する |
| PATCH（例: 2.1.1） | 言い回し・誤字・例の修正 |

エージェントは main ではなくタグを読む（main にはリリース前の書きかけが入る）。

- 新しくコーディングする → 最新のタグ
- 既存のモジュールを直す → そのモジュールが書かれたバージョンのタグ（Module Palette では `module.json` の `mp_version`）

## ファイル一覧

| ファイル | 中身 |
|---|---|
| [philosophy.md](philosophy.md) | 記法の思想・目的 |
| [naming.md](naming.md) | クラス名の組み立て方（プレフィックス、階層、継承、ケース、`_lv`、モディファイア、状態 `is_`） |
| [patterns.md](patterns.md) | パターン名の辞書（inner / body / group / list / card / ttl など） |
| [abbreviations.md](abbreviations.md) | 省略語と禁止語 |
| [html-format.md](html-format.md) | インデント・コメント・改行 |
| [html-attributes.md](html-attributes.md) | タグの選び方・属性・アクセシビリティ・JS との連携 |
| [responsive.md](responsive.md) | ブレークポイント・表示切り替え・流体値 |
| [scss.md](scss.md) | SCSS のファイル構成・書き方 |
| [module-format.md](module-format.md) | モジュールとして切り出すときの形式 |
| [checklist.md](checklist.md) | 検品の基準 |
| [open-questions.md](open-questions.md) | 未決の論点と次の版の予定 |
| [samples/](samples/README.md) | 記法で書いたモジュールの例（公開用のデザイン） |
| `global/` | samples/ の SCSS が読む mixin・ブレークポイント（[scss.md](scss.md) の `global/` のうち、モジュールが使う部分） |
