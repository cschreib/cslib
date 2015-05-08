; Interpolate between two color values.
;
; Arguments:
;  - c1: the first color
;  - c2: the second color
;  - x: the interpolation ratio (0.0 yields c1, 1.0 yields c2)
;
function color_interpol, c1, c2, x
    return, color(color_r(c1)*(1.0-x)+x*color_r(c2), color_g(c1)*(1.0-x)+x*color_g(c2), color_b(c1)*(1.0-x)+x*color_b(c2))
end
