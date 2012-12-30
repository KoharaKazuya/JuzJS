    controller_cache = {}
    publish = (canvas_selector)->
        controller_cache[canvas_selector] ?= new Controller($(canvas_selector), new PhysicsEngine())
