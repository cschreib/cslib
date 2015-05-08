; Extracts blue component from a 24-bits color value.
;
function color_b, c
    return, long(c)/65536L
end
