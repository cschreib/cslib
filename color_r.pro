; Extracts red component from a 24-bits color value.
;
function color_r, c
    return, long(c) mod 256L
end
