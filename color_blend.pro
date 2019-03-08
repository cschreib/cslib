; Blend two color values with alpha.
;
; Arguments:
;  - c1: the first color
;  - c2: the second color
;  - a1: alpha of first color
;  - a2: alpha of second color
;
function color_blend, c1, c2, a1, a2
    cu1 = color_unpack(c1)/255.0
    cu2 = color_unpack(c2)/255.0
    cu = (cu1*a1 + cu2*a2*(1.0 - a1))/(a1 + a2*(1.0 - a1))
    cu = byte(cu*255.0)
    return, color(cu[0], cu[1], cu[2])
end
