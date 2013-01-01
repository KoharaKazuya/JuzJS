    class Label

        @SEMITRANSPARENT: 0.3

        constructor: (@canvas, @id, @text, options)->
            pref = {
                layer: true
                name: @id
                group: "labels"
                fromCenter: true
                opacity: Label.SEMITRANSPARENT
            }
            if options?
                pref.fillStyle = options.color if options.color?
                pref.font = options.style if options.style?
                pref.maxWidth = options.width if options.width?
                if options.scaleOnMouseout?
                    pref.scale = options.scaleOnMouseout
                    pref.mouseover = (_)-> _.scale = 1
                    pref.mouseout = (_)-> _.scale = options.scaleOnMouseout
            else
                pref.fillStyle = "black"
                pref.font = "20pt sans-serif"
                pref.scale = 0.5
                pref.mouseover = (_)-> _.scale = 1
                pref.mouseout = (_)-> _.scale = 0.5
            @canvas.drawText(pref)

        destroy: -> @canvas.removeLayer(@id)

        setX: (new_x)-> @canvas.setLayer(@id, {x: new_x})
        setY: (new_y)-> @canvas.setLayer(@id, {y: new_y})

        appeal: ->
            @canvas.setLayer(@id, {opacity: 1})
            @canvas.moveLayer(@id, @canvas.getLayers().length-1)
