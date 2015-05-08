; Performs a simultaneous fit of several data sets that are assumed to have the same slope, but
; potentially different normalizations.
;
; Arguments:
;  - x, y, ye: the data to fit and the experimental errors on the fitted values
;  - id: array indicating which data set each point belongs to (must range from 0 to 'nset-1')
;  
; Keywords:
;  - err: [output] errors on the fit parameters
;  - slope: if set, fixes the slope of all data sets, and only fit the normalization. The procedure
;           is then strictly equivalent to 'nset' independent fits on each data set, so this keyword
;           is only provided for convenience.
;
function multifit, x, y, ye, id, err=err, slope=slope
    nfit = max(id)+1
    if provided(slope) then begin
        res = mpfitexpr('x.x*('+strn(slope)+') + p[x.id]', {x:x, id:id}, y, ye, fltarr(nfit), perror=err, /quiet)
        err = [0.0, err]
        return, [slope, res]
    endif else begin
        return, mpfitexpr('x.x*p[0] + p[x.id+1]', {x:x, id:id}, y, ye, [1.0, fltarr(nfit)], perror=err, /quiet)
    endelse
end
