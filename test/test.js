module("", {
    setup: function() {
        this.canvas = $("<canvas>");
        $("body").append(this.canvas);
        this.engine = new PhysicsEngine();
        this.im = new IDManager();
    },
    teardown: function() {
    }
});
test("ノード間の引力", function() {
    var node1 = new Node(this.canvas, this.im.getJCanvasUniqueName());
    var node2 = new Node(this.canvas, this.im.getJCanvasUniqueName());
    var node3 = new Node(this.canvas, this.im.getJCanvasUniqueName());
    var nodeList = [node1, node2, node3];
    node1.setX(0);
    node2.setX(100);
    node3.setX(200);

    equal(node1.getGravity(node2), 0, "引力の初期値は 0");
    equal(this.engine.computeGravity(node1, nodeList).getScalar(), 0, "引力が 0 なら加わる力も 0");
    node1.connect(node2, 1);
    equal(node1.getGravity(node2), 1, "引力を 1 に設定");
    equal(node2.getGravity(node1), 1, "相手から見ても同じ値に");
    equal(node1.getGravity(node1), 0, "別の設定には影響しない");
    equal(node1.getGravity(node3), 0, "別の設定には影響しない");
    equal(node2.getGravity(node2), 0, "別の設定には影響しない");
    equal(node2.getGravity(node3), 0, "別の設定には影響しない");
    equal(node3.getGravity(node1), 0, "別の設定には影響しない");
    equal(node3.getGravity(node2), 0, "別の設定には影響しない");
    equal(node3.getGravity(node3), 0, "別の設定には影響しない");
    ok(this.engine.computeGravity(node1, nodeList).getScalar() > 0, "引力が 1 なら加わる力は 0 以上");
    node2.connect(node3, 2);
    ok(this.engine.computeGravity(node1, nodeList).getScalar() <
        this.engine.computeGravity(node3, nodeList).getScalar(), "引力が大きく設定されているほど加わる力も大きくなる");
});
test("コネクション", function() {
    var src = new Node(this.canvas, this.im.getJCanvasUniqueName());
    var dest = new Node(this.canvas, this.im.getJCanvasUniqueName());
    var connection = new Connection(
        this.canvas, this.im.getJCanvasUniqueName(),
        src.getX(), src.getY(), dest.getX(), dest.getY(), 1);
    equal(connection.getSrcX(), src.getX(), "コネクションの元ノードが設定されているか");
    equal(connection.getSrcY(), src.getY(), "コネクションの元ノードが設定されているか");
    equal(connection.getDestX(), dest.getX(), "コネクションの元ノードが設定されているか");
    equal(connection.getDestY(), dest.getY(), "コネクションの元ノードが設定されているか");
    equal(connection.strength, 1, "コネクションの強さが設定されているか");
});
