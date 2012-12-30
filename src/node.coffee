class Node

    constructor: (@canvas, @id)->
        @canvas.addLayer({
            name: @id
            type: "image"
            draggable: true
            cursor: "pointer"
            })

    setIcon: (src, options)->
        layer = @canvas.getLayer(@id)
        layer.source = src
        if options?
            layer.opacity = options.opacity if options.opacity?

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
        @gravities ?= {}
        gravity = @gravities[other.id]
        gravity ?= 0

    setGravity: (other, value)->
        @gravities ?= {}
        @gravities[other.id] = value
        other.setGravity(this, value) if other.getGravity(this) != value
