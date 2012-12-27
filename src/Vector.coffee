class Vector

    constructor: (_scalar, _angle)->
        scalar = _scalar
        angle = _angle

    scalar: 0
    angle: 0

    add: (other)->
        new_scalar = Math.sqrt(Math.pow(scalar, 2) + Math.pow(other.scalar, 2) + 2*scalar*other.scalar*Math.cos(angle-other.angle))
        new_angle = Math.acos((scalar*Math.cos(angle) + other.scalar*Math.cos(other.angle))/new_scalar)
        new Vector(new_scalar, new_angle)
