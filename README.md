# 地理院地図Vectorのスタイルを<br>シンプルなMapbox GL JSで実装する試み
実装例　https://mghs15.github.io/map2/map.html
Mapboxのサービスと合わせた例　https://mghs15.github.io/map2/map2.html
（Mapboxの提供するOpenStreetMapのPOIとlanduseを上乗せ）


## モチベーション
[地理院地図Vector（仮称）提供実験](https://github.com/gsi-cyberjapan/gsimaps-vector-experiment)のスタイル設定ファイルは、そのままではMapbox GL JSのスタイル設定ファイル（[Mapbox Style Specification](https://docs.mapbox.com/mapbox-gl-js/style-spec/)）に利用できないため、なんとか簡単に変換するすべを考えてみた。

## 出来上がったツール

### ツールのURLとベースとしたサイト
ツールのURL　https://mghs15.github.io/map2/tool

[地理院地図Vectorのサイト](https://maps.gsi.go.jp/vector/)を無理やり改造した。変更ファイルは 以下の通り。
- index.html
- [js/src/map/layer-binaryvectortile.js](https://mghs15.github.io/map2/tool/js/src/map/layer-binaryvectortile.js) 

### 使い方
使い方としては、各スタイルを読み込むとデベロッパーツールのコンソールにMapbox Style Specificationの["layers"](https://docs.mapbox.com/mapbox-gl-js/style-spec/#root-layers)に該当する部分の設定ファイルが出力されるので、
これをMapbox GL JSのスタイル設定ファイルにコピペしてあげればよい。

```
"layers":[

ここにコピペ

]
```

テンプレートはこちら→https://github.com/mghs15/map2/template.json


コピペ後の各style.jsonには、以下の修正が必要
- ["sources"](https://docs.mapbox.com/mapbox-gl-js/style-spec/#root-sources)に必要なid（gsibv-vectortile-source-1-5-18など）を持ったデータソースの設定をしてあげる
- ["sprite"](https://docs.mapbox.com/mapbox-gl-js/style-spec/#root-sprite)の設定を適宜変更
- <gsi-vertical>タグを削除
	- 削除ツールはこちら（perl製）→ https://github.com/mghs15/map2/perl/delete-gsi-vertical-tag.pl 
	- 本当は["concat"](https://docs.mapbox.com/mapbox-gl-js/style-spec/#expressions-concat)ごと削除したいが、JSONが崩れ、やる気をなくしたため保留。
- ["icon-image"](https://docs.mapbox.com/mapbox-gl-js/style-spec/#layout-symbol-icon-image)の値を整理
	- "std///田"のようになっているので、"田"に直す。
	- 修正ツールはこちら（perl製）→ https://github.com/mghs15/map2/perl/replace_sprite.pl 


### 今回ためしに作成したもの

<table>
	<tr>
		<td><a href="https://github.com/mghs15/sstd.json">標準地図</a></td>
		<td><a href="https://github.com/mghs15/spale.json">淡色地図</a></td>
		<td><a href="https://github.com/mghs15/sblank.json">白地図</a></td>
	</tr>
	<tr>
		<td><a href="https://github.com/mghs15/sphoto.json">写真</a></td>
		<td><a href="https://github.com/mghs15/slabel.json">写真＋注記の注記</a></td>
		<td><a href="https://github.com/mghs15/sllabel.json">大きい注記の地図</a></td>
	</tr>
	<tr>
		<td><a href="https://github.com/mghs15/sstd2.json">標準地図2</a></td>
		<td><a href="https://github.com/mghs15/spale2.json">淡色地図2</a></td>
		<td><a href="https://github.com/mghs15/sblank2.json">白地図2</a></td>
	</tr>
</table>

※実装例　https://mghs15.github.io/map2/map.html 　で表示できるものです。


## 課題
1. 注記でHTMLが入っている場合、処理ができていない。
- とりあえず、<gsi-vertical>タグを削除することにした。
2. 記号をspriteファイルからうまく取り出せていない。
- "icon-image":"田"のように、アイコン名（sprite.jsonで定義されているもの）をシンプルにダブルクオーテーションで囲む形にすれば解決した。
- どうやら、["sprite"](https://docs.mapbox.com/mapbox-gl-js/style-spec/#sprite)では、自動的に sprite@2x.png のようにScale Factorが付与されるらしい。これに対応していないと、スマホ等での閲覧に支障があるかもしれない。
3. オリジナルの「MySimple.json」で、フォントファイルの読み込みがうまくいかない
- ["text-font"](https://docs.mapbox.com/mapbox-gl-js/style-spec/#layout-symbol-text-font)（layout property）の設定が必要だったようだ。





