    class Controller

        constructor: (@canvas, @engine)->
            @nodeList = []
            @IDManager = new IDManager()
            @start()

        createNode: (events)->
            node = new Node(@canvas, @IDManager.getJCanvasUniqueName(), events)
            @nodeList.push node
            node

        removeNode: (node)->
            index = @nodeList.indexOf(node)
            throw new Error("削除するように指定したノードが見つかりません") if index == -1
            @nodeList = @nodeList.slice(0, index).concat(@nodeList.slice(index+1, @nodeList.length))
            node.destroy()

        start: ->
            @updater = setInterval(=>
                @engine.update(@nodeList, @canvas)
                @canvas.drawLayers()
            , 1000 / 60)

        stop: -> clearInterval(@updater)
