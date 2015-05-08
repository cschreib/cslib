; Make a color darker
; Note:
;   With frac=1, the output color is black, with frac=0, the output color is the
;   input color.
;
function color_darken, col, frac
    if n_elements(col) gt 1 then begin
        ret = col
        for i=0, n_elements(col)-1 do ret[i] = color_darken(col[i], frac)
        return, ret
    endif else begin
        return, color(clamp(color_unpack(col)*(1.0 - frac),0,255))
    endelse
end
