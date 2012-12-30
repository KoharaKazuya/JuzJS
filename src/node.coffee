    class Node

        SUPPORTED_EVENTS: [
            "click"
            "dblclick"
            "mousedown"
            "mouseup"
            "mousemove"
            "mouseover"
            "mouseout"
            "dragstart"
            "drag"
            "dragstop"
            "touchstart"
            "touchend"
            "touchmove"
        ]

        constructor: (@canvas, @id, events)->
            pref = {
                name: @id
                type: "image"
                draggable: true
                cursor: "pointer"
                }
            if events?
                for event, fn of events
                    throw new Error("サポートされていないイベントです。") if @SUPPORTED_EVENTS.indexOf(event) == -1
                    pref[event] = (layer)=> fn(this, layer.eventX, layer.eventY)
            @canvas.addLayer(pref)
            @outConnections = {}
            @inConnections = {}

        destroy: ->
            @canvas.removeLayer(@id)
            for id, obj of @outConnections
                obj.connection.destroy()
                delete obj.node.inConnections[@id]
            for id, obj of @inConnections
                obj.connection.destroy()
                delete obj.node.outConnections[@id]

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
            for id, obj of @outConnections
                obj.connection.setSrcX(new_x)
            for id, obj of @inConnections
                obj.connection.setDestX(new_x)

        setY: (new_y)->
            new_y = Math.min(Math.max(0, new_y), @canvas.height())
            @canvas.getLayer(@id).y = Math.round(new_y)
            for id, obj of @outConnections
                obj.connection.setSrcY(new_y)
            for id, obj of @inConnections
                obj.connection.setDestY(new_y)

        getGravity: (other)->
            outs = @outConnections[other.id]
            return outs.connection.strength if outs
            ins = @inConnections[other.id]
            return ins.connection.strength if ins
            0

        connect: (other, strength, text, text_options)->
            con = new Connection(@canvas, "from_" + this.id + "_to_" + other.id,
                this.getX(), this.getY(), other.getX(), other.getY(), strength, text, text_options)
            @outConnections[other.id] = { node: other, connection: con }
            other.inConnections[this.id] = { node: this, connection: con }
