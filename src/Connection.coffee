# ノード間のつながり
class Connection

    constructor: (@canvas, @id, @node1, @node2)->
        @canvas.drawLine({
            layer: true
            name: @id
            strokeStyle: "black"
            })

    getStrength: ->
        @strength

    setStrength: (value)->
        @node1.setGravity(@node2, value)
        @node2.setGravity(@node1, value)
        @strength = value

    update: ->
        layer = @canvas.getLayer(@id)
        layer.x1 = @node1.getX()
        layer.y1 = @node1.getY()
        layer.x2 = @node2.getX()
        layer.y2 = @node2.getY()
