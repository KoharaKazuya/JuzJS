class Node
    draw: (c)->
        c.beginPath()
        c.arc(100, 100, 40, 0, Math.PI*2, true)
        c.stroke()
