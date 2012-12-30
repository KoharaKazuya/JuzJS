$(function() {

    var NODE_NUM = 10;
    var CANVAS = $("canvas");
    var ENGINE = new PhysicsEngine();

    var im = new IDManager();
    var nodeList = [];
    for (var i=0; i<NODE_NUM; ++i) {
        nodeList[i] = new Node(CANVAS, im.getJCanvasUniqueName());
    }

    function u() {
        ENGINE.update(nodeList);
        CANVAS.drawLayers();
        setTimeout(u, 1000.0 / 60);
    }
    u();
});
