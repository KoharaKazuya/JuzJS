    class JuzJSObject

        constructor: (@canvas, @id)->

        destroy: -> @canvas.removeLayer(@id)

        getX: -> @canvas.getLayer(@id).x
        getY: -> @canvas.getLayer(@id).y
        setX: (new_x)-> @canvas.setLayer(@id, {x: new_x})
        setY: (new_y)-> @canvas.setLayer(@id, {y: new_y})
