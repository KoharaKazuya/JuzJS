class PhysicsEngine

    REPLUSION_BASE: 100

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
                if node == other then continue
                vect = point2Vector(node).sub(point2Vector(other))
                v = v.add(Vector.polar2rect(REPLUSION_BASE / vect.getScalar(), vect.getAngle()))
            v

    # ノードの位置ベクトルを取得
    point2Vector: (node)->
        new Vector(node.getX(), node.getY())
