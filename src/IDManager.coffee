class IDManager
    jcanvas_id_counter: 0
    getJCanvasUniqueName: ->
        "jCanvas_id_" + jcanvas_id_counter++
