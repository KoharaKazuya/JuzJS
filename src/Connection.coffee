# ノード間のつながり
class Connection

    constructor: (@canvas, @id, sx, sy, dx, dy, @strength, text, text_options)->
        @canvas.drawLine({
            layer: true
            name: @id
            strokeStyle: "black"
            x1: sx
            y1: sy
            x2: dx
            y2: dy
            })
        @canvas.drawText({
            layer: true
            name: @id + "_label"
            fromCenter: true
            })
        if text?
            @setLabel(text, text_options)
        else
            @setLabel("")

    getSrcX: -> @canvas.getLayer(@id).x1
    getSrcY: -> @canvas.getLayer(@id).y1
    getDestX: -> @canvas.getLayer(@id).x2
    getDestY: -> @canvas.getLayer(@id).y2

    setSrcX: (value)->
        @canvas.getLayer(@id).x1 = value
        @update()
    setSrcY: (value)->
        @canvas.getLayer(@id).y1 = value
        @update()
    setDestX: (value)->
        @canvas.getLayer(@id).x2 = value
        @update()
    setDestY: (value)->
        @canvas.getLayer(@id).y2 = value
        @update()

    update: ->
        layer = @canvas.getLayer(@id)
        label = @canvas.getLayer(@id + "_label")
        label.x = (layer.x1 + layer.x2) / 2
        label.y = (layer.y1 + layer.y2) / 2

    setLabel: (text, options)->
        layer = @canvas.getLayer(@id + "_label")
        layer.text = text
        if options?
            layer.fillStyle = options.color if options.color?
            layer.font = options.style if options.style?
            layer.maxWidth = options.width if options.width?
            if options.scaleOnMouseout
                layer.scale = options.scaleOnMouseout
                layer.mouseover = (_)-> _.scale = 1
                layer.mouseout = (_)-> _.scale = options.scaleOnMouseout
        else
            layer.fillStyle = "black"
            layer.font = "20pt sans-serif"
            layer.scale = 0.5
            layer.mouseover = (_)-> _.scale = 1
            layer.mouseout = (_)-> _.scale = 0.5
