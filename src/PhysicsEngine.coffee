class PhysicsEngine

    update: (nodeList)->
        replusionVectors = computeReplusion(nodeList)
        gravityVectors = computeGravity(nodeList)
        resistanceVectors = computeResistance(nodeList)
        updateSpeed(nodeList)
        updatePosition(nodeList)

