    # ノード間のつながり
    class Connection

        @SEMITRANSPARENT: 0.3

        constructor: (@canvas, @id, @strength, @label)->
            @canvas.drawLine({
                layer: true
                name: @id
                index: 0
                group: "connections"
                strokeStyle: "black"
                })

        destroy: ->
            @canvas.removeLayer(@id)
            @label.destroy()

        getSrcX: -> @canvas.getLayer(@id).x1
        getSrcY: -> @canvas.getLayer(@id).y1
        getDestX: -> @canvas.getLayer(@id).x2
        getDestY: -> @canvas.getLayer(@id).y2

        setSrcX: (value)->
            @canvas.getLayer(@id).x1 = value
            @labelUpdate()
        setSrcY: (value)->
            @canvas.getLayer(@id).y1 = value
            @labelUpdate()
        setDestX: (value)->
            @canvas.getLayer(@id).x2 = value
            @labelUpdate()
        setDestY: (value)->
            @canvas.getLayer(@id).y2 = value
            @labelUpdate()
        labelUpdate: ->
            layer = @canvas.getLayer(@id)
            @label.setX((layer.x1 + layer.x2) / 2)
            @label.setY((layer.y1 + layer.y2) / 2)

        appeal: ->
            @canvas.setLayer(@id, {opacity: 1})
            @label.appeal()

