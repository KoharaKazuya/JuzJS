class PhysicsEngine

    REPLUSION_BASE: 100
    GRAVITY_BASE: 0.01

    update: (nodeList)->
        replusionVectors = computeReplusion(nodeList)
        gravityVectors = computeGravity(nodeList)
        resistanceVectors = computeResistance(nodeList)
        updateSpeed(nodeList)
        updatePosition(nodeList)

    # 斥力を計算
    computeReplusion: (nodeList)->
        for node in nodeList
            v = new Vector(0, 0)
            for other in nodeList
                continue if node == other
                vect = point2Vector(node).sub(point2Vector(other))
                v = v.add(Vector.polar2rect(REPLUSION_BASE / vect.getScalar(), vect.getAngle()))
            v

    # 引力を計算
    computeGravity: (nodeList)->
        for node in nodeList
            v = new Vector(0, 0)
            for other in nodeList
                continue if node == other
                vect = point2Vector(other).sub(point2Vector(node))
                v = v.add(Vector.polar2rect(GRAVITY_BASE * vect.getScalar(), vect.getAngle()))
            v

    # ノードの位置ベクトルを取得
    point2Vector: (node)->
        new Vector(node.getX(), node.getY())
