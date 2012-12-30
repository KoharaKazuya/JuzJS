$(function() {

    var NODE_NUM = 10;
    var CANVAS = $("canvas");
    var ENGINE = new PhysicsEngine();

    var im = new IDManager();
    var nodeList = [];
    for (var i=0; i<NODE_NUM; ++i) {
        nodeList[i] = new Node(CANVAS, im.getJCanvasUniqueName());
    }

    connectionList = [];
    connectionList[0] = new Connection(CANVAS, im.getJCanvasUniqueName(),
        nodeList[0], nodeList[1]);
    connectionList[0].setStrength(1);
    connectionList[1] = new Connection(CANVAS, im.getJCanvasUniqueName(),
        nodeList[1], nodeList[2]);
    connectionList[1].setStrength(0.5);

    function u() {
        ENGINE.update(nodeList);
        for (var i=0; i<connectionList.length; ++i) {
            connectionList[i].update();
        }
        CANVAS.drawLayers();
        setTimeout(u, 1000.0 / 60);
    }
    u();
});
