; Overplot upper or lower limits.
;
; Arguments:
;  - x, y: position of the data points
;  - ye: [optional] error on the limits
;
; Keywords:
;  - upper: plot upper limits (default)
;  - lower: plot lower limits
;  - + all keywords available to 'oplot'
;
pro olimplot, x, y, ye, lower=lower, upper=upper, symsize=symsize, color=color, _extra=pextra
    if ~provided(symsize) then symsize = 1.0
    if keyword_set(upper) or ~keyword_set(lower) then begin
        oplot, x, y, psym=symcat(18), symsize=symsize, color=color, _extra=pextra
        errplot, x, y, y, color=color, width=0.03*symsize
        if provided(ye) then errplot, x, y, y-ye, color=color
    endif else begin
        oplot, x, y, psym=symcat(17), symsize=symsize, color=color, _extra=pextra
        errplot, x, y, y, color=color, width=0.03*symsize
        if provided(ye) then errplot, x, y, y+ye, color=color
    endelse
end
