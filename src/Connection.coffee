# ノード間のつながり
class Connection

    constructor: (@canvas, @id, @node1, @node2)->
        @canvas.drawLine({
            layer: true
            name: @id
            strokeStyle: "black"
            x1: @node1.getX()
            y1: @node1.getY()
            x2: @node2.getX()
            y2: @node2.getY()
            })
