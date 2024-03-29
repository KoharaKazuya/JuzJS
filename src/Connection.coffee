    # ノード間のつながり
    class Connection extends JuzJSObject

        constructor: (canvas, id, @strength, @label)->
            super(canvas, id)
            @canvas.drawLine({
                layer: true
                name: @id
                index: 0
                group: "connections"
                strokeStyle: "black"
                })
            @setSrcX(0)
            @setSrcY(0)
            @setDestX(0)
            @setDestY(0)

        destroy: ->
            super()
            @label.destroy()

        getX: -> throw "this function is disabled in Connection"
        getY: -> throw "this function is disabled in Connection"
        setX: (new_x)-> throw "this function is disabled in Connection"
        setY: (new_y)-> throw "this function is disabled in Connection"

        getSrcX: -> @canvas.getLayer(@id).x1
        getSrcY: -> @canvas.getLayer(@id).y1
        getDestX: -> @canvas.getLayer(@id).x2
        getDestY: -> @canvas.getLayer(@id).y2

        setSrcX: (value)->
            @canvas.setLayer(@id, {x1: value})
            @labelUpdate()
        setSrcY: (value)->
            @canvas.setLayer(@id, {y1: value})
            @labelUpdate()
        setDestX: (value)->
            @canvas.setLayer(@id, {x2: value})
            @labelUpdate()
        setDestY: (value)->
            @canvas.setLayer(@id, {y2: value})
            @labelUpdate()
        labelUpdate: ->
            layer = @canvas.getLayer(@id)
            @label.setX((layer.x1 + layer.x2) / 2)
            @label.setY((layer.y1 + layer.y2) / 2)

        appeal: ->
            @canvas.setLayer(@id, {opacity: 1})
            @label.appeal()

