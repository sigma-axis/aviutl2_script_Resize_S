# Resize_S AviUtl ExEdit2 スクリプト

各種拡大縮小フィルタを適用する，標準の `リサイズ` の機能拡張版です．次の拡大縮小フィルタを適用できます．

- 拡大フィルタ
  1.  最近傍法
  1.  双線形
  1.  Mitchell-Netravali
  1.  Catmull-Rom
  1.  Lanczos 2
  1.  Lanczos 3

- 縮小フィルタ
  1.  最近傍法
  1.  単純平均
  1.  双線形
  1.  Hamming
  1.  Lanczos 2
  1.  Lanczos 3

加えてオブジェクトを特定サイズの矩形内に収めたり，特定サイズの矩形を覆うように拡大するフィルタ効果もあります．

[ダウンロードはこちら．](https://github.com/sigma-axis/aviutl2_script_Resize_S/releases)

##  動作要件

- AviUtl ExEdit2

  http://spring-fragrance.mints.ne.jp/aviutl

  - `beta3` で動作確認済み．

##  導入方法

以下のフォルダのいずれかに `@Resize_S.anm2` をコピーしてください．

1.  `%ProgramData%` 内の `aviutl2/Script` フォルダ
    - 通常は `C:/ProgramData/aviutl2/Script` フォルダ

1.  (1) のフォルダにある任意の名前のフォルダ

初期状態だと「フィルタ効果を追加」メニューの「変形」に「リサイズσ@Resize_S」と「ボックスリサイズσ@Resize_S」が追加されています．
- 「オブジェクト追加メニューの設定」の「ラベル」項目で分類を変更できます．

##  リサイズσ

指定したアルゴリズムで画像に拡大縮小フィルタを適用します．

![リサイズσの GUI](https://github.com/user-attachments/assets/4839bc77-7524-4e0e-8db8-be0a4c56b67b)

### `拡大率`

画像の拡大率を縦横一律に指定します．[`ピクセル数でサイズ指定`](#ピクセル数でサイズ指定) の場合でも，[`X`, `Y`](#x-y) のサイズに乗じて適用されます．

% 単位で最小値は `0.000`, 最大値は `5000.000`, 初期値は `100.000`.

### `X`, `Y`

画像の拡大率を縦横個別に指定します．

[`ピクセル数でサイズ指定`](#ピクセル数でサイズ指定) の場合，画像のピクセル数を縦横それぞれ指定します．
- `X`, `Y` に [`拡大率`](#拡大率) を乗じた後，四捨五入で最終的なピクセル数が決定されます．

% 単位で最小値は `0.000`, 最大値は `5000.000`, 初期値は `100.000`.
- [`ピクセル数でサイズ指定`](#ピクセル数でサイズ指定) の場合はピクセル単位．

### `中心の位置を変更`

拡大縮小の中心を，回転中心と画像の中央のどちらにするか指定します．
- OFF の場合は回転中心．
- ON の場合は画像の中央．

初期値は OFF.

### `ピクセル数でサイズ指定`

[`X`, `Y`](#x-y) の項目が，元画像からの拡大率ではなくピクセル数の指定になります．

初期値は OFF.

### `拡大方法`, `縮小方法`

拡大縮小に使用するアルゴリズムを指定します．

####  `拡大方法`

拡大時に使用するアルゴリズムです．次の選択肢があります．

1.  最近傍法
    - 標準の `リサイズ` を `補間なし` で適用したのと同じ．
1.  双線形
    - 標準の `リサイズ` を `補間なし` を OFF で適用したのと同じ．
1.  [Mitchell-Netravali](https://ja.wikipedia.org/wiki/ミッチェル・ネトラバリ・フィルター)
    - $B=C=\frac{1}{3}$ とした特殊化．
1.  [Catmull-Rom](https://en.wikipedia.org/wiki/Cubic_Hermite_spline#Catmull%E2%80%93Rom_spline)
1.  [Lanczos 2](https://en.wikipedia.org/wiki/Lanczos_resampling)
1.  [Lanczos 3](https://en.wikipedia.org/wiki/Lanczos_resampling)

初期値は Lanczos 3 です．

- [PI](#pi) で指定する際の数値との対応は以下の通りです:

  |数値|指定|
  |:---:|:---:|
  |`0`|最近傍法|
  |`1`|双線形|
  |`2`|Mitchell-Netravali|
  |`3`|Catmull-Rom|
  |`4`|Lanczos 2|
  |`5`|Lanczos 3|

####  `縮小方法`

縮小時に使用するアルゴリズムです．次の選択肢があります．

1.  最近傍法
    - 標準の `リサイズ` を `補間なし` で適用したのと同じ．
1.  単純平均
    - 標準の `リサイズ` を `補間なし` を OFF で適用したのと同じ．
1.  双線形
    - 双線形補間の重みで元画像のピクセルの平均を計算します．
1.  [Hamming](https://en.wikipedia.org/wiki/Window_function#Hamming_window)
    - 関数の各点での値を重みとして元画像のピクセルの平均を計算します．
1.  [Lanczos 2](https://en.wikipedia.org/wiki/Lanczos_resampling)
1.  [Lanczos 3](https://en.wikipedia.org/wiki/Lanczos_resampling)

初期値は Lanczos 3 です．

- [PI](#pi) で指定する際の数値との対応は以下の通りです:

  |数値|指定|
  |:---:|:---:|
  |`0`|最近傍法|
  |`1`|単純平均|
  |`2`|双線形|
  |`3`|Hamming|
  |`4`|Lanczos 2|
  |`5`|Lanczos 3|

### `PI`

パラメタインジェクション (parameter injection) です．初期値は空欄. テーブル型の中身として解釈され，各種パラメタの代替値として使用されます．また，任意のスクリプトコードを実行する記述領域にもなります．

```lua
{
  zoom = zoom, -- number 型で "拡大率" の項目を上書き，または nil.
  sz = { x, y }, -- table 型で "X", "Y" の項目を上書き，または nil.
  move_center = move_center, -- boolean 型で "中心の位置を変更" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  absolute = absolute, -- boolean 型で "ピクセル数でサイズ指定" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  upscale = upscale, -- number 型で "拡大方法" の項目を上書き，または nil.
  downscale = downscale, -- number 型で "縮小方法" の項目を上書き，または nil.
}
```
- テキストボックスには冒頭末尾の波括弧 (`{}`) を省略して記述してください．

##  ボックスリサイズσ

![適用例](https://github.com/user-attachments/assets/3405f41a-b611-4965-aaff-184b03f7feef)


指定したサイズの矩形に合うように拡大縮小フィルタを適用します．矩形内に収まる最大サイズや，矩形を覆う最小サイズを自動的に計算してそのサイズに拡大縮小します．

![ボックスリサイズσの GUI](https://github.com/user-attachments/assets/ce533e96-78b0-455b-9ac2-9e5fcf32e07a)

### `X`, `Y`

基準となる矩形サイズを指定します．[`モード`](#モード) に応じて最終的な画像サイズが計算されます．

ピクセル単位で最小値は `0`, 最大値は `5000`, 初期値は `256`.

### `モード`

画像サイズを [`X`, `Y`](#x-y-1) で指定されたサイズにどのように合わせるかを指定します．次の選択肢があります:

1.  内接最大

    `X`, `Y` で指定されたサイズ内に収まるように画像を拡大縮小します．

1.  外接最小

    `X`, `Y` で指定されたサイズ全体を覆うように画像を拡大縮小します．

初期値は内接最大.

- [PI](#pi-1) で指定する際の数値との対応は以下の通りです:

  |数値|指定|
  |:---:|:---:|
  |`0`|内接最大|
  |`1`|外接最小|

### `拡大縮小`

元画像サイズと [`X`, `Y`](#x-y-1) 指定の大小関係に応じて，拡大縮小を制御します．

次の選択肢があります．

1.  拡縮両方

    大小関係によらず拡大または縮小します．

1.  拡大のみ

    元画像が小さい場合にのみ拡大フィルタを適用します．縮小フィルタは適用しません．

1.  縮小のみ

    元画像が大きい場合にのみ縮小フィルタを適用します．拡大フィルタは適用しません．

初期値は拡縮両方.

- [PI](#pi-1) で指定する際の数値との対応は以下の通りです:

  |数値|指定|
  |:---:|:---:|
  |`0`|拡縮両方|
  |`1`|拡大のみ|
  |`2`|縮小のみ|

### `中心の位置を変更`

拡大縮小の中心を，回転中心と画像の中央のどちらにするか指定します．
- OFF の場合は回転中心．
- ON の場合は画像の中央．

初期値は ON.

### `余白/クリッピング`

拡大縮小の結果，一般には [`X`, `Y`](#x-y-1) で指定した矩形と縦横どちらかの長さが異なります．この差の分だけ，足りない部分は余白で埋めたり，余剰分をクリッピングしたりして，最終的なサイズを `X`, `Y` での指定に調整します．

初期値は ON.

### `水平揃え`, `垂直揃え`

[`余白/クリッピング`](#余白クリッピング) が ON の場合のみ有効．[`X`, `Y`](#x-y-1) で指定した矩形の配置を指定します．

1.  `-100` だと，左/上揃え．
1.  `100` だと，右/下揃え．
1.  `0` だと，中央揃え．
1.  その他の値の場合，以上を線形に補間した位置．

% 単位で最小値は `-100.000`, 最大値は `100.000`, 初期値は `0.000`.

### `拡大方法`, `縮小方法`

[`リサイズσ` の `拡大方法`, `縮小方法`](#拡大方法-縮小方法) と同様です．

初期値は両方とも Lanczos 3 です．

### `PI`

パラメタインジェクション (parameter injection) です．初期値は空欄. テーブル型の中身として解釈され，各種パラメタの代替値として使用されます．また，任意のスクリプトコードを実行する記述領域にもなります．

```lua
{
  sz = { x, y }, -- table 型で "X", "Y" の項目を上書き，または nil.
  mode = mode, -- number 型で "モード" の項目を上書き，または nil.
  dir = dir, -- number 型で "拡大縮小" の項目を上書き，または nil.
  move_center = move_center, -- boolean 型で "中心の位置を変更" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  crop_pad = crop_pad, -- boolean 型で "余白/クリッピング" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  align = { ax, ay }, -- table 型で "水平揃え", "垂直揃え" の項目を上書き，または nil.
  upscale = upscale, -- number 型で "拡大方法" の項目を上書き，または nil.
  downscale = downscale, -- number 型で "縮小方法" の項目を上書き，または nil.
}
```
- テキストボックスには冒頭末尾の波括弧 (`{}`) を省略して記述してください．

##  既知の問題

1.  `拡大方法` が「最近傍法」か「双線形」，または `縮小方法` が「最近傍法」か「単純平均」を選択している状態で，縦横比が異なる拡大・縮小を適用した場合，意図した通りのサイズにならないことがあります．

    これは `AviUtl ExEdit2 beta3` で確認されているバグに起因します．標準の「リサイズ」フィルタ効果で `拡大率` や `X` が初期値のまま `Y` を変化させてもフィルタが適用されないというものです．

1.  `標準描画` の `中心X` や `中心Y` が 0 でない場合，[`中心の位置を変更`](#中心の位置を変更) が OFF でも拡大縮小の中心が回転中心からずれてしまいます．

    これら `中心X` や `中心Y` ([patch.aul](https://github.com/ePi5131/patch.aul) での `obj.getvalue("cx")` や `obj.getvalue("cy")` に相当するもの) が取得できないため回転中心の座標計算が正確にはできず，現状解決策がありません．

    テキストオブジェクトの文字揃えに伴う回転中心の変更などは正しく反映されます．

## 改版履歴

- **v1.00 (for beta3)** (2025-07-??)

  - 初版．


## ライセンス

このプログラムの利用・改変・再頒布等に関しては MIT ライセンスに従うものとします．

---

The MIT License (MIT)

Copyright (C) 2025 sigma-axis

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

https://mit-license.org/


#  連絡・バグ報告

- GitHub: https://github.com/sigma-axis
- Twitter: https://x.com/sigma_axis
- nicovideo: https://www.nicovideo.jp/user/51492481
- Misskey.io: https://misskey.io/@sigma_axis
- Bluesky: https://bsky.app/profile/sigma-axis.bsky.social
