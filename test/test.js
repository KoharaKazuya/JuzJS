module("", {
    setup: function() {
        this.canvas = $("canvas");
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
    node2.setX(10);
    node3.setX(20);

    equal(node1.getGravity(node2), 0, "引力の初期値は 0");
    equal(this.engine.computeGravity(node1, nodeList).getScalar(), 0, "引力が 0 なら加わる力も 0");
    node1.setGravity(node2, 1);
    equal(node1.getGravity(node2), 1, "引力を 1 に設定");
    equal(node2.getGravity(node2), 0, "別の設定には影響しない");
    equal(node2.getGravity(node1), 1, "相手から見ても同じ値に");
    ok(this.engine.computeGravity(node1, nodeList).getScalar() > 0, "引力が 1 なら加わる力は 0 以上");
    node2.setGravity(node3, 2);
    ok(this.engine.computeGravity(node1, nodeList).getScalar() <
        this.engine.computeGravity(node3, nodeList).getScalar(), "引力が大きく設定されているほど加わる力も大きくなる");
});
test("コネクション", function() {
    var src = new Node(this.canvas, this.im.getJCanvasUniqueName());
    var dest = new Node(this.canvas, this.im.getJCanvasUniqueName());
    var connection = new Connection(
        this.canvas, this.im.getJCanvasUniqueName(),
        src.getX(), src.getY(), dest.getX(), dest.getY(), 1);
    deepEqual(connection.getSrcX(), src.getX(), "コネクションの元ノードが設定されているか");
    deepEqual(connection.getSrcY(), src.getY(), "コネクションの元ノードが設定されているか");
    deepEqual(connection.getDestX(), src.getX(), "コネクションの元ノードが設定されているか");
    deepEqual(connection.getDestY(), src.getY(), "コネクションの元ノードが設定されているか");
    equal(connection.getStrength(), 1, "コネクションの強さが設定されているか");
});
// test("別ノードとの接続", function() {
//     var node1 = new Node(this.canvas, this.im.getJCanvasUniqueName());
//     var node2 = new Node(this.canvas, this.im.getJCanvasUniqueName());
//     node1.connect(node2, 1);
//     equal(node1.getGravity(node2), 1, "コネクションの設定が引力に直接反映");
//     equal(node2.getGravity(node1), 1, "コネクションの設定が引力に直接反映");
// });
