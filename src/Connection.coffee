# ノード間のつながり
class Connection

    constructor: (@canvas, @id, @node1, @node2)->
        @canvas.drawLine({
            layer: true
            name: @id
            strokeStyle: "black"
            })
        @canvas.drawText({
            layer: true
            name: @id + "_label"
            fillStyle: "black"
            strokeStyle: "white"
            fromCenter: true
            })
        @setLabel("", {
            style: "20pt sans-serif"
            scaleOnMouseout: 0.5
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
        label = @canvas.getLayer(@id + "_label")
        label.x = (@node1.getX() + @node2.getX()) / 2
        label.y = (@node1.getY() + @node2.getY()) / 2

    setLabel: (text, options)->
        layer = @canvas.getLayer(@id + "_label")
        layer.text = text
        if options?
            layer.font = options.style if options.style?
            layer.maxWidth = options.width if options.width?
            if options.scaleOnMouseout
                layer.scale = options.scaleOnMouseout
                layer.mouseover = (_)-> _.scale = 1
                layer.mouseout = (_)-> _.scale = options.scaleOnMouseout

