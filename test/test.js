$(function() {
    var im = new IDManager();
    var node1 = new Node($("canvas"), im.getJCanvasUniqueName());
    var node2 = new Node($("canvas"), im.getJCanvasUniqueName());
    var engine = new PhysicsEngine();

    node1.setX(30);

    function u() {
        engine.update([node1, node2]);
        $("canvas").drawLayers();
        setTimeout(u, 1000.0 / 60);
    }
    u();
});
