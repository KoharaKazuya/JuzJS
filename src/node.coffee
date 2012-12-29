class Node

    canvas: undefined
    id: undefined

    constructor: (canvas_)->
        canvas = canvas_
        id = IDManager.getJCanvasUniqueName()
        canvas.drawArc({
            layer: true
            name: id
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
        canvas.getLayer(id).x

    getY: ->
        canvas.getLayer(id).y
