; Extracts red, green and blue components from a 24-bits color value.
;
function color_unpack, c
    intc = long(c)
    r = intc mod 256L
    g = (intc/256L) mod 256L
    b = intc/65536L
    return, [r,g,b]
end
