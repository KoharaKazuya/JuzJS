$(function() {

    var controller = JuzJS("canvas");

    var NODE_NUM = 500;

    var nodeList = [];
    for (var i=0; i<NODE_NUM; ++i) {
        nodeList[i] = controller.createNode({
            mouseover: function(node, ex, ey) {
                console.log(ex);
            },
            dblclick: function(node, ex, ey) {
                alert("(" + ex + "," + ey + ") at (" + node.getX() + "," + node.getY() + ")");
            }
        });
        nodeList[i].setX($("canvas").attr('width') / 2);
        nodeList[i].setY($("canvas").attr('height') / 2);
        nodeList[i].setIcon("https://si0.twimg.com/profile_images/2504370963/6u5qf6cl9jtwew6poxcj_normal.png");
    }

    nodeList[0].connect(nodeList[1], 1, "とりあえず");
    nodeList[0].connect(nodeList[1], 1, "スラッシュ族, BiographyConnector, JuzJS", {
        style: "bold 20pt メイリオ",
        width: 100,
        color: "green",
        scaleOnMouseout: 0.8
    });
    nodeList[1].connect(nodeList[2], 0.5, "何か");
    nodeList[1].disconnect(nodeList[2]);
    nodeList[3].connect(nodeList[4]);
    nodeList[3].connect(nodeList[5]);
    controller.removeNode(nodeList[3]);
});
