    class Node extends JuzJSObject

        constructor: (canvas, id, events)->
            super(canvas, id)
            pref = {
                name: @id
                type: "image"
                draggable: true
                cursor: "pointer"
                opacity: Preference.SEMITRANSPARENT
                group: "nodes"
                }
            default_events = {
                mouseover: (layer)=> @appeal()
            }
            for event in Preference.SUPPORTED_EVENTS
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
            super
            for id, obj of @outConnections
                obj.connection.destroy()
                delete obj.node.inConnections[@id]
            for id, obj of @inConnections
                obj.connection.destroy()
                delete obj.node.outConnections[@id]

        setIcon: (src, options)->
            layer = @canvas.getLayer(@id)
            layer.source = src

        setX: (new_x)->
            icon_width = @canvas.getLayer(@id).width / 2
            new_x = Math.min(Math.max(icon_width, new_x), @canvas.width()-icon_width)
            super(new_x)
            for id, obj of @outConnections
                obj.connection.setSrcX(new_x)
            for id, obj of @inConnections
                obj.connection.setDestX(new_x)

        setY: (new_y)->
            icon_height = @canvas.getLayer(@id).height / 2
            new_y = Math.min(Math.max(icon_height, new_y), @canvas.height()-icon_height)
            super(new_y)
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
            id = "from_" + this.id + "_to_" + other.id
            con = new Connection(@canvas, id, strength,
                new Label(@canvas, id + "_label", text, text_options))
            @outConnections[other.id] = { node: other, connection: con }
            other.inConnections[this.id] = { node: this, connection: con }

        disconnect: (other)->
            if (other.id of @outConnections) && (this.id of other.inConnections)
                @outConnections[other.id].connection.destroy()
                delete @outConnections[other.id]
                delete other.inConnections[this.id]
            if (other.id of @inConnections) && (this.id of other.outConnections)
                @inConnections[other.id].connection.destroy()
                delete @inConnections[other.id]
                delete other.outConnections[this.id]

        appeal: ->
            # 関連するノードの強調表示
            @canvas.setLayerGroup("nodes", {
                opacity: Preference.SEMITRANSPARENT
                })
            last = @canvas.getLayers().length-1
            for id, v of @outConnections
                @canvas.setLayer(id, {opacity: 1})
                @canvas.moveLayer(id, last)
            for id, v of @inConnections
                @canvas.setLayer(id, {opacity: 1})
                @canvas.moveLayer(id, last)
            @canvas.setLayer(@id, {opacity: 1})
            @canvas.moveLayer(@id, last)
            # 関連するコネクションの強調表示
            @canvas.setLayerGroup("connections", {opacity: Preference.SEMITRANSPARENT})
            @canvas.setLayerGroup("labels", {opacity: Preference.SEMITRANSPARENT})
            for id, v of @outConnections
                v.connection.appeal()
            for id, v of @inConnections
                v.connection.appeal()
