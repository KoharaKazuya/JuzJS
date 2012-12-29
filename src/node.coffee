class Node

    constructor: (@canvas, @id)->
        @canvas.drawArc({
            layer: true
            name: @id
            fillStyle: "black"
            x: 100
            y: 100
            radius: 40
            draggable: true
            click: (layer)->
                $(this).setLayer(layer, {
                    fillStyle: "red"
                    })
            })

    getX: ->
        @canvas.getLayer(@id).x

    getY: ->
        @canvas.getLayer(@id).y

    setX: (new_x)->
        @canvas.getLayer(@id).x = new_x

    setY: (new_y)->
        @canvas.getLayer(@id).y = new_y
