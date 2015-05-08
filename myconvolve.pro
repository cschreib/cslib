; Convolve a curve with a kernel.
; See the description of the keyword 'single' for more information on the two possible way to use
; this function.
;
; Arguments:
;  - x, y: the curve
;  - xk, yk: the kernel
;
; Keywords:
;  - single: if set, simply compute the product of the kernel and the curve, resulting in a single
;            scalar value (example: convolve a detector response curve to a spectrum to obtain an
;            observed flux). If not set, the product of the curve and the kernel is computed at each
;            point of the curve, recentering the kernel so that its center lies on the current point
;            (example: smooth out a curve with a gaussian kernel).
;
function myconvolve, x, y, xk, yk, single=single
    if keyword_set(single) then begin
        yl = interpol(y, x, xk)
        return, int_tabulated(xk, yl*yk)/int_tabulated(xk, yk)
    endif else begin
        yc = y
        npt = n_elements(x)
        
        knorm = int_tabulated(xk, yk)
        
        for i=0L, npt-1L do begin
            xl = xk + x[i]
            yl = interpol(y, x, xl)
            yc[i] = int_tabulated(xl, yl*yk)/knorm
        endfor

        return, yc
    endelse
end

