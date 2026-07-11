# Resize_S AviUtl ExEdit2 スクリプト

各種拡大縮小フィルタを適用する，標準の「リサイズ」の機能拡張版です．次の拡大縮小フィルタを適用できます．

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

![Overview](https://github.com/user-attachments/assets/3f0f9db6-6c2f-448a-b26a-d4e1e233b106)
- 元画像: https://www.pexels.com/photo/vegetables-and-tomatoes-on-cutting-board-255501

[ダウンロードはこちら．](https://github.com/sigma-axis/aviutl2_script_Resize_S/releases) [紹介動画．](https://www.nicovideo.jp/watch/sm45220623)

##  お願い

このスクリプトを使った動画などでは，ニコニコの親作品にこのスクリプトの紹介動画を登録してくれると嬉しいです．任意ではありますが，登録してくれたほうが励みになります．

- 登録 ID: `sm45220623`

##  動作要件

- AviUtl ExEdit2

  http://spring-fragrance.mints.ne.jp/aviutl

  - `2.0.54` で動作確認済み．

##  導入方法

ダウンロードした `aviutl2_script_Resize_S-v*.**.au2pkg.zip` を AviUtl2 のウィンドウにドラッグ & ドロップしてください．

初期状態だと「フィルタ効果を追加」メニューの「Resize_S」に「リサイズσ@Resize_S」と「ボックスリサイズσ@Resize_S」が追加されています．
- 「オブジェクト追加メニューの設定」の「ラベル」項目で分類を変更できます．

### For non-Japanese speaking users

You may be able to find language translation file for this script from [this repository](https://github.com/sigma-axis/aviutl2_translations_sigma-axis). 
Translation files enable names and parameters of the scripts / filters to be displayed in other languages.

Although, usage documentations for this script in languages other than Japanese are not available now.

##  リサイズσ

指定したアルゴリズムで画像に拡大縮小フィルタを適用します．

### 拡大率

画像の拡大率を縦横一律に指定します．[「ピクセル数でサイズ指定」](#ピクセル数でサイズ指定)の場合でも，[「X」「Y」](#x--y)のサイズに乗じて適用されます．

% 単位で最小値は 0, 最大値は 5000, 初期値は 100.

### X / Y

画像の拡大率を縦横個別に指定します．

[「ピクセル数でサイズ指定」](#ピクセル数でサイズ指定)の場合，画像のピクセル数を縦横それぞれ指定します．
- 「X」「Y」に[「拡大率」](#拡大率)を乗じた後，四捨五入で最終的なピクセル数が決定されます．

% 単位で最小値は 0, 最大値は 5000, 初期値は 100.
- [「ピクセル数でサイズ指定」](#ピクセル数でサイズ指定)が ON の場合はピクセル単位．

### 中心の位置を変更

拡大縮小の中心を，回転中心と画像の中央のどちらにするか指定します．
- OFF の場合は回転中心．
- ON の場合は画像の中央．

初期値は OFF.

### ピクセル数でサイズ指定

[「X」「Y」](#x--y)の項目が，元画像からの拡大率ではなくピクセル数の指定になります．

初期値は OFF.

### 拡大方法 / 縮小方法

拡大縮小に使用するアルゴリズムを指定します．

####  拡大方法

拡大時に使用するアルゴリズムです．次の選択肢があります．

1.  `最近傍法`
    - 標準の「リサイズ」を「補間なし」を ON で適用したのと同じ．
1.  `双線形`
    - 標準の「リサイズ」を「補間なし」を OFF で適用したのと同じ．
1.  [`Mitchell-Netravali`](https://ja.wikipedia.org/wiki/ミッチェル・ネトラバリ・フィルター)
    - $B=C=\frac{1}{3}$ とした特殊化．
1.  [`Catmull-Rom`](https://en.wikipedia.org/wiki/Cubic_Hermite_spline#Catmull%E2%80%93Rom_spline)
1.  [`Lanczos2`](https://en.wikipedia.org/wiki/Lanczos_resampling)
1.  [`Lanczos3`](https://en.wikipedia.org/wiki/Lanczos_resampling)

初期値は `Lanczos3` です．

####  縮小方法

縮小時に使用するアルゴリズムです．次の選択肢があります．

1.  `最近傍法`
    - 標準の「リサイズ」を「補間なし」を ON で適用したのと同じ．
1.  `単純平均`
    - 標準の「リサイズ」を「補間なし」を OFF で適用したのと同じ．
1.  `双線形`
    - 双線形補間の重みで元画像のピクセルの平均を計算します．
1.  [`Hamming`](https://en.wikipedia.org/wiki/Window_function#Hamming_window)
    - 関数の各点での値を重みとして元画像のピクセルの平均を計算します．
1.  [`Lanczos2`](https://en.wikipedia.org/wiki/Lanczos_resampling)
1.  [`Lanczos3`](https://en.wikipedia.org/wiki/Lanczos_resampling)

初期値は `Lanczos3` です．

### PI

パラメタインジェクション (parameter injection) です．初期値は空欄. テーブル型の中身として解釈され，各種パラメタの代替値として使用されます．また，任意のスクリプトコードを実行する記述領域にもなります．

```lua
{
  zoom = num,         -- number 型で "拡大率" の項目を上書き，または nil.
  sz = { x, y },      -- table 型で "X", "Y" の項目を上書き，または nil.
  absolute = bool,    -- boolean 型で "ピクセル数でサイズ指定" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  upscale = str,      -- string 型で "拡大方法" の項目を上書き，または nil.
  downscale = str,    -- string 型で "縮小方法" の項目を上書き，または nil.
  move_center = bool, -- boolean 型で "中心の位置を変更" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
}
```
- テキストボックスには冒頭末尾の波括弧 (`{}`) を省略して記述してください．

##  ボックスリサイズσ

![適用例](https://github.com/user-attachments/assets/3405f41a-b611-4965-aaff-184b03f7feef)
- 元画像: https://www.pexels.com/photo/assorted-color-kittens-45170

指定したサイズの矩形に合うように拡大縮小フィルタを適用します．矩形内に収まる最大サイズや，矩形を覆う最小サイズを自動的に計算してそのサイズに拡大縮小します．

### X / Y / 背景サイズ

基準となる矩形サイズを指定します．[「モード」](#モード)に応じて最終的な画像サイズが計算されます．

- 「X」「Y」でピクセル単位でサイズを指定します．

  最小値は 0, 最大値は 5000, 初期値は 256.

- 「背景サイズ」が ON の場合「X」「Y」の設定を無視して，シーンのサイズにします．

  初期値は OFF.

### モード

画像サイズを[「X」「Y」や「背景サイズ」](#x--y--背景サイズ)で指定されたサイズにどのように合わせるかを指定します．次の選択肢があります:

1.  `内接最大`

    「X」「Y」で指定されたサイズ内に収まるように画像を拡大縮小します．

1.  `外接最小`

    「X」「Y」で指定されたサイズ全体を覆うように画像を拡大縮小します．

初期値は `内接最大`.

### 拡大縮小

元画像サイズと[「X」「Y」や「背景サイズ」](#x--y--背景サイズ)指定の大小関係に応じて，拡大縮小を制御します．

次の選択肢があります．

1.  `拡縮両方`

    大小関係によらず拡大または縮小します．

1.  `拡大のみ`

    元画像が小さい場合にのみ拡大フィルタを適用します．縮小フィルタは適用しません．

1.  `縮小のみ`

    元画像が大きい場合にのみ縮小フィルタを適用します．拡大フィルタは適用しません．

初期値は `拡縮両方`.

### 中心の位置を変更

拡大縮小の中心を，回転中心と画像の中央のどちらにするか指定します．
- OFF の場合は回転中心．
- ON の場合は画像の中央．

初期値は ON.

### 余白/クリッピング

拡大縮小の結果，一般には[「X」「Y」や「背景サイズ」](#x--y--背景サイズ)で指定した矩形と縦横どちらかの長さが異なります．この差の分だけ，足りない部分は余白で埋めたり，余剰分をクリッピングしたりして，最終的なサイズを「X」「Y」での指定に調整します．

初期値は ON.

### 水平揃え / 垂直揃え

[「余白/クリッピング」](#余白クリッピング)が ON の場合のみ有効．[「X」「Y」や「背景サイズ」](#x--y--背景サイズ)で指定した矩形の配置を指定します．

1.  -100 だと，左/上揃え．
1.  100 だと，右/下揃え．
1.  0 だと，中央揃え．
1.  その他の値の場合，以上を線形に補間した位置．

% 単位で最小値は -100, 最大値は 100, 初期値は 0.

### 拡大方法, 縮小方法

[「リサイズσ」の「拡大方法」「縮小方法」](#拡大方法--縮小方法)と同様です．

初期値は両方とも `Lanczos3` です．

### PI

パラメタインジェクション (parameter injection) です．初期値は空欄. テーブル型の中身として解釈され，各種パラメタの代替値として使用されます．また，任意のスクリプトコードを実行する記述領域にもなります．

```lua
{
  sz = { x, y },      -- table 型で "X", "Y" の項目を上書き，または nil.
  screen_size = bool, -- boolean 型で "背景サイズ" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  mode = num,         -- number 型で "モード" の項目を上書き，または nil.
  dir = num,          -- number 型で "拡大縮小" の項目を上書き，または nil.
  upscale = num,      -- number 型で "拡大方法" の項目を上書き，または nil.
  downscale = num,    -- number 型で "縮小方法" の項目を上書き，または nil.
  align = { x, y },   -- table 型で "水平揃え", "垂直揃え" の項目を上書き，または nil.
  move_center = bool, -- boolean 型で "中心の位置を変更" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  crop_pad = bool,    -- boolean 型で "余白/クリッピング" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
}
```
- テキストボックスには冒頭末尾の波括弧 (`{}`) を省略して記述してください．

## 改版履歴

- **v1.30** (2026-07-12)

  - 「ボックスリサイズσ」に「背景サイズ」のパラメタを追加．

- **v1.20** (2026-07-11)

  - 一部パラメタにツールチップ表示を追加．
  - トラックバーのマウス操作倍率指定や，中間点区間ごとに可変なチェックボックスに置き換えなど UI 調整．
  - 初期ラベル (メニュー内の分類) を「変形」から「Resize_S」に変更．
  - コード整理．
  - 配布形式を `.au2pkg.zip` (AviUtl2 のパッケージ形式) に変更．
    - **以前のバージョンから更新する際は，以前の導入時にコピーしたファイルを一度削除してから導入してください．**

      同名ファイルが複数フォルダに分散して重複して認識されないようにするためで，次のファイルが削除対象です:

      1.  `@Resize_S.anm2`

      スクリプトフォルダ，またはその 1 階層下のサブフォルダ内に配置されています．

  - `2.0.54` で動作確認．

- **v1.11 (for beta25)** (2025-12-22)

  - パラメタをグループ化して整理．
  - パラメタインジェクションの一部のパラメタで文字列型を受け付けるように．
  - `beta25` で動作確認．

- **v1.10 (for beta13)** (2025-09-30)

  - `中心の位置を変更` が OFF の場合に `標準描画` の `中心X` や `中心Y` の値を反映するよう変更．
    - AviUtl ExEdit `beta12` の追加機能を利用．拡大縮小の中心が回転中心からずれなくなりました．
    - 破壊的変更になるので，過去バージョンでのプロジェクトファイルだと位置ずれを起こす可能性があります．

  - `beta13` で動作確認．

- **v1.01 (for beta4)** (2025-07-27)

  - `beta4` で動作確認．
  - バグ修正に伴って，バグ対処のためのコードを削除．

- **v1.00 (for beta3)** (2025-07-24)

  - 初版．


## ライセンス

このプログラムの利用・改変・再頒布等に関しては MIT ライセンスに従うものとします．

---

The MIT License (MIT)

Copyright (C) 2025-2026 sigma-axis

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
