    class PhysicsEngine

        update: (nodeList, canvas)->
            if nodeList.length > Preference.MAX_UPDATABLE_NODES_NUM
                updateList = []
                list = [0...nodeList.length]
                while updateList.length < Preference.MAX_UPDATABLE_NODES_NUM
                    r = Math.floor(Math.random() * list.length)
                    updateList.push nodeList[list[r]]
                    list.splice(r, 1)
            else
                updateList = nodeList
            forceList = for node in updateList
                replusionVector = @computeReplusion(node, nodeList)
                gravityVector   = @computeGravity(node, nodeList)
                centerizeVector = @computeCenterize(node, canvas)
                replusionVector.add(gravityVector).add(centerizeVector)
            @updatePosition(updateList, forceList)

        # 斥力を計算
        computeReplusion: (node, nodeList)->
            v = new Vector(0, 0)
            for other in nodeList
                continue if node == other
                vect = @point2Vector(node).sub(@point2Vector(other))
                div = Math.pow(vect.getScalar(), 2)
                if div == 0  # 0 での除算の防止
                    v = v.add(Vector.polar2rect(Preference.REPLUSION_BASE, 2 * Math.PI * Math.random()))
                else
                    v = v.add(Vector.polar2rect(Preference.REPLUSION_BASE / div, vect.getAngle()))
                v = @limitedForce(v)
            v

        # 引力を計算
        computeGravity: (node, nodeList)->
            v = new Vector(0, 0)
            for other in nodeList
                continue if node == other
                g = node.getGravity(other)
                continue if g == 0
                vect = @point2Vector(other).sub(@point2Vector(node))
                v = v.add(Vector.polar2rect(g * Preference.GRAVITY_BASE * Math.pow(vect.getScalar(), 2), vect.getAngle()))
                v = @limitedForce(v)
            v

        # 中央への引力を計算
        computeCenterize: (node, canvas)->
            center_x = canvas.attr("width") / 2
            center_y = canvas.attr("height") / 2
            new Vector(center_x, center_y).sub(@point2Vector(node))

        # 1 フレームでかかる力を制限する
        limitedForce: (vector)->
            vector.x = Math.min(Math.max(-1000, vector.x), 1000)
            vector.y = Math.min(Math.max(-1000, vector.y), 1000)
            vector

        # ノードの位置を更新
        updatePosition: (nodeList, forceList)->
            for i in [0...nodeList.length]
                node = nodeList[i]
                force = forceList[i]
                node.setX(node.getX() + force.x * Preference.UPDATE_SPEED)
                node.setY(node.getY() + force.y * Preference.UPDATE_SPEED)

        # ノードの位置ベクトルを取得
        point2Vector: (node)->
            new Vector(node.getX(), node.getY())
