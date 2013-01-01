    class Node

        @SEMITRANSPARENT = 0.3
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
                opacity: Node.SEMITRANSPARENT
                group: "nodes"
                }
            default_events = {
                mouseover: (layer)=> @appeal()
            }
            for event in @SUPPORTED_EVENTS
                do (event)=>
                    pref[event] = (layer)=>
                        fn = default_events[event]
                        fn(layer) if fn
                        fn = events[event]
                        fn(this, layer.eventX, layer.eventY) if fn
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

        getX: ->
            @canvas.getLayer(@id).x

        getY: ->
            @canvas.getLayer(@id).y

        setX: (new_x)->
            icon_width = @canvas.getLayer(@id).width / 2
            new_x = Math.min(Math.max(icon_width, new_x), @canvas.width()-icon_width)
            @canvas.getLayer(@id).x = Math.round(new_x)
            for id, obj of @outConnections
                obj.connection.setSrcX(new_x)
            for id, obj of @inConnections
                obj.connection.setDestX(new_x)

        setY: (new_y)->
            icon_height = @canvas.getLayer(@id).height / 2
            new_y = Math.min(Math.max(icon_height, new_y), @canvas.height()-icon_height)
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
            @disconnect(other)
            con = new Connection(@canvas, "from_" + this.id + "_to_" + other.id,
                this.getX(), this.getY(), other.getX(), other.getY(), strength, text, text_options)
            @outConnections[other.id] = { node: other, connection: con }
            other.inConnections[this.id] = { node: this, connection: con }

        disconnect: (other)->
            if (other.id of @outConnections) && (this.id of other.inConnections)
                @outConnections[other.id].connection.destroy()
                delete @outConnections[other.id]
                delete other.inConnections[this.id]

        appeal: ->
            @canvas.setLayerGroup("nodes", {
                opacity: Node.SEMITRANSPARENT
                })
            @canvas.setLayer(@id, {opacity: 1})
            for id, v of @outConnections
                @canvas.setLayer(id, {opacity: 1})
            for id, v of @inConnections
                @canvas.setLayer(id, {opacity: 1})
