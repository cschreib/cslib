; Generate a 24-bits color value from 'red', 'green' and 'blue' 8-bits components.
; For this function to work properly, all the provided arguments should have values that range
; between 0 and 255.
;
function color, r, g, b
    if n_elements(g) eq 0 then begin
        return, long(r[0]) + long(r[1])*256L + long(r[2])*65536L
    endif else begin
        return, long(r) + long(g)*256L + long(b)*65536L
    endelse
end
