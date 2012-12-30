module("", {
    setup: function() {
        this.canvas = $("canvas");
        this.im = new IDManager();
    },
    teardown: function() {
    }
});
test("ノード間の引力", function() {
    var node1 = new Node(this.canvas, this.im.getJCanvasUniqueName());
    var node2 = new Node(this.canvas, this.im.getJCanvasUniqueName());
    equal(node1.getGravity(node2), 0, "引力の初期値は 0");
    node1.setGravity(node2, 1);
    equal(node2.getGravity(node2), 1, "引力を 1 に設定");
});
