$(function() {
    var im = new IDManager();
    var node1 = new Node($("canvas"), im);
    var node2 = new Node($("canvas"), im);
    var engine = new PhysicsEngine();
    engine.update([node1, node2]);
});
