# 地理院地図Vectorのスタイルを<br>シンプルなMapbox GL JSで実装する試み
- 実装例　https://mghs15.github.io/map2/map.html
- Mapboxのサービスと合わせた例　https://mghs15.github.io/map2/map2.html
（[Mapbox](https://www.mapbox.com/about/maps/)の提供する[OpenStreetMap](https://www.openstreetmap.org/about/)のPOIとlanduseを上乗せ）

※独自スタイルでは、建物を3D表示していますが、あくまでイメージです。その他、細かい調整等は行っておりません。

## モチベーション
[地理院地図Vector（仮称）提供実験](https://github.com/gsi-cyberjapan/gsimaps-vector-experiment)のスタイル設定ファイルは、
そのままではMapbox GL JSのスタイル設定ファイル（[Mapbox Style Specification](https://docs.mapbox.com/mapbox-gl-js/style-spec/)）に利用できないため、なんとか簡単に変換する方法を考えてみた。

## 出来上がったツール

### ツールのURLとベースとしたサイト
ツールのURL　https://mghs15.github.io/map2/tool

[地理院地図Vectorのサイト](https://maps.gsi.go.jp/vector/)を無理やり改造した。変更ファイルは 以下の通り。
- index.html
- [js/src/map/layer-binaryvectortile.js](https://mghs15.github.io/map2/tool/js/src/map/layer-binaryvectortile.js) 
- css/common.css

### 使い方
1. 上記サイトで、変換したいスタイルをロードする。
	- おすすめの地図のほか、自分で作成したスタイルを読み込んでも良い。
2. ロードが完了すると、自動的にMapbox Gl JSが読み込める形のスタイルへ変換処理を行う。
	- 同時に、左のパネル中ほど、「ダウンロード」ボタンの左（場合によっては上）にロードしたスタイルのタイトルが（自分で作成したスタイルの場合は"（読込）"の文字も一緒に）表示される。
	- ラスタの情報や地理院地図Vector独自の実装については削除されるので注意。
	- 編集機能を用いてスタイルを変更しても、反映されないので注意。
3. 「ダウンロード」ボタンを押すと、Mapbox Gl JSが読み込める形のstyle.jsonがダウンロードされる。
4. ["sprite"](https://docs.mapbox.com/mapbox-gl-js/style-spec/#root-sprite)に設定されたspriteファイルのURLは、おすすめ地図の「標準地図、注記＋写真、大きい文字、標準地図②」以外は淡色地図用になるので、自分でスタイルを読み込む場合等は、必要に応じて、手動で標準地図用に変換する。
	- 標準地図用spriteファイルURL　https://cyberjapandata.gsi.go.jp/vector/sprite/std
	- 淡色地図用spriteファイルURL　https://cyberjapandata.gsi.go.jp/vector/sprite/pale

### 手動での取出し
上記の使い方がうまくいかなったとき等は下記の方法を試す。

各スタイルを読み込むとデベロッパーツールのコンソールにMapbox Style Specificationの["layers"](https://docs.mapbox.com/mapbox-gl-js/style-spec/#root-layers)に該当する部分の設定ファイルが出力されるので、
これをMapbox GL JSのスタイル設定ファイルにコピペしてあげればよい。

```
"layers":[

ここにコピペ

]
```

テンプレートはこちら→https://mghs15.github.io/map2/template.json


コピペ後の各style.jsonには、以下の修正が必要
- ["sources"](https://docs.mapbox.com/mapbox-gl-js/style-spec/#root-sources)に必要なid（gsibv-vectortile-source-1-4-17など）を持ったデータソースの設定をしてあげる
- ["sprite"](https://docs.mapbox.com/mapbox-gl-js/style-spec/#root-sprite)の設定を適宜変更
- <gsi-vertical>タグを削除
	- 削除ツールはこちら（Perl製）→ https://github.com/mghs15/map2/blob/master/perl/delete-gsi-vertical-tag.pl 
	- 本当は["concat"](https://docs.mapbox.com/mapbox-gl-js/style-spec/#expressions-concat)ごと削除したいが、JSONが崩れ、やる気をなくしたため保留。
- ["icon-image"](https://docs.mapbox.com/mapbox-gl-js/style-spec/#layout-symbol-icon-image)の値を整理
	- "std///田"のようになっているので、"田"に直す。
	- 修正ツールはこちら（Perl製）→ https://github.com/mghs15/map2/blob/master/perl/replace_sprite.pl 


### 今回ためしに作成したもの

<table>
	<tr>
		<td><a href="https://mghs15.github.io/map2sstd.json">標準地図</a></td>
		<td><a href="https://mghs15.github.io/map2spale.json">淡色地図</a></td>
		<td><a href="https://mghs15.github.io/map2sblank.json">白地図</a></td>
	</tr>
	<tr>
		<td><a href="https://mghs15.github.io/map2sphoto.json">写真</a></td>
		<td><a href="https://mghs15.github.io/map2slabel.json">写真＋注記の注記</a></td>
		<td><a href="https://mghs15.github.io/map2sllabel.json">大きい注記の地図</a></td>
	</tr>
	<tr>
		<td><a href="https://mghs15.github.io/map2sstd2.json">標準地図2</a></td>
		<td><a href="https://mghs15.github.io/map2spale2.json">淡色地図2</a></td>
		<td><a href="https://mghs15.github.io/map2sblank2.json">白地図2</a></td>
	</tr>
</table>

※実装例（ https://mghs15.github.io/map2/map.html ）で表示できるものです。


## 課題
1. 注記でHTMLが入っている場合、処理ができていない。
	- とりあえず、<gsi-vertical>タグを削除することにした。
2. 記号をspriteファイルからうまく取り出せていない。
	- "icon-image":"田"のように、アイコン名（sprite.jsonで定義されているもの）をシンプルにダブルクオーテーションで囲む形にすれば解決した。
	- どうやら、["sprite"](https://docs.mapbox.com/mapbox-gl-js/style-spec/#sprite)では、自動的に sprite@2x.png のようにScale Factorが付与されるらしい。これに対応していないと、スマホ等での閲覧に支障がある。
3. オリジナルの「MySimple.json」で、フォントファイルの読み込みがうまくいかない
	- ["text-font"](https://docs.mapbox.com/mapbox-gl-js/style-spec/#layout-symbol-text-font)（layout property）の設定が必要だったようだ。





