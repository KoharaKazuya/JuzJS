# 極座標系のベクトル
class Vector

    constructor: (@x, @y)->

    # 大きさと角度からベクトルを生成する
    polar2rect: (scalar, angle)->
        new_x = scalar * Math.cos(angle)
        new_y = scalar * Math.sin(angle)
        new Vector(new_x, new_y)

    getScalar: ->
        Math.sqrt(Math.pow(@x, 2) + Math.pow(@y, 2))

    getAngle: ->
        if @x == 0
            if @y < 0
                - Math.PI / 2
            else if @y > 0
                Math.PI / 2
            else
                0
        else
            Math.atan(@y / @x)

    add: (other)->
        new Vector(@x + other.x, @y + other.y)

    sub: (other)->
        new Vector(@x - other.x, @y - other.y)

