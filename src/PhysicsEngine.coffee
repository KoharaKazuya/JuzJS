class PhysicsEngine

    REPLUSION_BASE: 100
    GRAVITY_BASE: 0.01
    UPDATE_SPEED: 0.01

    update: (nodeList)->
        forceList = for node in nodeList
            replusionVector = @computeReplusion(node, nodeList)
            gravityVector = @computeGravity(node, nodeList)
            replusionVector.add(gravityVector)
        @updatePosition(nodeList, forceList)

    # 斥力を計算
    computeReplusion: (node, nodeList)->
        v = new Vector(0, 0)
        for other in nodeList
            continue if node == other
            vect = @point2Vector(node).sub(@point2Vector(other))
            v = v.add(Vector.polar2rect(@REPLUSION_BASE / Math.pow(vect.getScalar(), 2), vect.getAngle()))
        v

    # 引力を計算
    computeGravity: (node, nodeList)->
        v = new Vector(0, 0)
        for other in nodeList
            continue if node == other
            vect = @point2Vector(other).sub(@point2Vector(node))
            v = v.add(Vector.polar2rect(@GRAVITY_BASE * Math.pow(vect.getScalar(), 2), vect.getAngle()))
        v

    # ノードの位置を更新
    updatePosition: (nodeList, forceList)->
        for i in [0...nodeList.length]
            node = nodeList[i]
            force = forceList[i]
            node.setX(node.getX() + force.x * @UPDATE_SPEED)
            node.setY(node.getY() + force.y * @UPDATE_SPEED)

    # ノードの位置ベクトルを取得
    point2Vector: (node)->
        new Vector(node.getX(), node.getY())
