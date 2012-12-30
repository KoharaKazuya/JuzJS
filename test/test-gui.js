$(function() {

    var NODE_NUM = 10;
    var CANVAS = $("canvas");
    var ENGINE = new PhysicsEngine();

    var im = new IDManager();
    var nodeList = [];
    for (var i=0; i<NODE_NUM; ++i) {
        nodeList[i] = new Node(CANVAS, im.getJCanvasUniqueName());
    }

    nodeList[0].setGravity(nodeList[1], 1);
    nodeList[1].setGravity(nodeList[2], 0.5);

    function u() {
        ENGINE.update(nodeList);
        CANVAS.drawLayers();
        setTimeout(u, 1000.0 / 60);
    }
    u();
});
