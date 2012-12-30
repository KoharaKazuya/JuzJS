$(function() {

    var controller = new Controller($("canvas"), new PhysicsEngine());

    var NODE_NUM = 10;

    var nodeList = [];
    for (var i=0; i<NODE_NUM; ++i) {
        nodeList[i] = controller.createNode({
            dblclick: function(node, ex, ey) {
                alert("(" + ex + "," + ey + ") at (" + node.getX() + "," + node.getY() + ")");
            }
        });
        nodeList[i].setIcon("https://si0.twimg.com/profile_images/2504370963/6u5qf6cl9jtwew6poxcj_normal.png", {
            opacity: 0.5
        });
    }

    nodeList[0].connect(nodeList[1], 1, "スラッシュ族, BiographyConnector, JuzJS", {
        style: "bold 20pt メイリオ",
        width: 100,
        color: "green",
        scaleOnMouseout: 0.8
    });
    nodeList[1].connect(nodeList[2], 0.5, "何か");

    controller.removeNode(nodeList[2]);
});
