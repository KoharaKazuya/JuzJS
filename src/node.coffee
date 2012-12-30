class Node

    gravities: {}

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
        new_x = Math.min(Math.max(0, new_x), @canvas.width())
        @canvas.getLayer(@id).x = Math.round(new_x)

    setY: (new_y)->
        new_y = Math.min(Math.max(0, new_y), @canvas.height())
        @canvas.getLayer(@id).y = Math.round(new_y)

    getGravity: (other)->
        gravity = @gravities[other]
        gravity ?= 0

    setGravity: (other, value)->
        @gravities[other] = value
