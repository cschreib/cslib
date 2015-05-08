; Extracts green component from a 24-bits color value.
;
function color_g, c
    return, (long(c)/256L) mod 256L
end
