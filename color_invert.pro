; Invert a 24bit color.
; Examples:
;   white   <->     black
;   red     <->     cyan
;   green   <->     magenta
;   blue    <->     yellow
;
function color_invert, c
    rgb = color_unpack(c)
    rgb = 255 - rgb
    return, color(rgb)
end
