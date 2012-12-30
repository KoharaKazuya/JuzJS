JuzJS
=====

これは何？
----------
人物相関図やネットワーク図などのグラフを Javascript でインタラクティブに簡単に扱えるようにしようというライブラリです。

HTML5 の Canvas を使用します。


必要ライブラリ
--------------
- jQuery
- jCanvas


API
---
### (グローバル)
- JuzJS(*selector*) : キャンバス要素に対応したコントローラーを取得
    - *selector* : jQuery のセレクタと同じ。Canvas 要素を指定
    - **return** : Canvas 要素に対応したコントローラー

### Controller
- createNode(\[*events*\]) : 新しくノードを生成し取得
    - *events* : 以下のイベントをキーとし実行する関数を値とした連想配列
        - イベント
            - click
            - dblclick
            - mousedown
            - mouseup
            - mousemove
            - mouseover
            - mouseout
            - dragstart
            - drag
            - dragstop
            - touchstart
            - touchend
            - touchmove
        - callback(*node*, *eventX*, *eventY*)
            - *node* : イベントが発生したノード自信
            - *eventX* : イベントが発生したキャンバス内でのX座標
            - *eventY* : イベントが発生したキャンバス内でのY座標
    - **return** : 生成したノード
- removeNode(*node*) : ノードを削除
    - *node* : ノード
- start() : シミュレーション（ノードの自動位置調整）の開始
- stop() : シミュレーションの停止

### Node
- setIcon(*src*\[, *options*\]) : ノードに画像を設定
    - *src* : 画像の URL
    - *options* : 連想配列
        - opacity : 不透明度を \[0, 1\] で指定
- getX() : ノードの中心のX座標を取得
- getY() : ノードの中心のY座標を取得
- setX(*value*) : ノードの中心のX座標を設定
    - *value* : 座標
- setY(*value*) : ノードの中心のY座標を設定
    - *value* : 座標
- connect(*other*, *strength*\[, *text*, *text_options*\]) : 2ノード間の接続を設定
    - *other* : ノード
    - *strength* : 接続強度。\[0, 1\] で指定
    - *text* : 接続名
    - *text_options* : 連想配列
        - color : 文字色
        - style : CSS の font で指定するのもと同じ。フォント
        - width : 一行の最大幅（あくまでも折り返しの目安で保証されない）
        - scaleOnMouseout : マウスが接続名上に**ない**ときの拡大率を \[0, 1\] で指定


### 使用例


読み方は？
----------
じゅずじぇーえす
