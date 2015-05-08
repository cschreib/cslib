; Make a 24bit color lighter.
; Note:
;   With frac=1, the output color is white, with frac=0, the output color is the
;   input color.
;
function color_lighten, col, frac
    if n_elements(col) gt 1 then begin
        ret = col
        for i=0, n_elements(col)-1 do ret[i] = color_lighten(col[i], frac)
        return, ret
    endif else begin
        return, color(clamp(color_unpack(col) + (255 - color_unpack(col))*frac,0,255))
    endelse
end
