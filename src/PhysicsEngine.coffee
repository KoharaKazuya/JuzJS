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
                vect = point2Vector(other, node)
                v = v.add(new Vector(REPLUSION_BASE / Math.pow(vect.scalar, 2), vect.angle))
            v

    # 2地点のノードの座標からベクトルを計算する
    point2Vector: (origin, dest)->
