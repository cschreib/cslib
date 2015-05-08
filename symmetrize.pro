; Symmetrizes a data set by truncating it somewhere and mirorring the remaining data.
; Assumes that the data is sorted in 'x'.
;
; Arguments:
;  - xdata, ydata: the data to symmetrize
;  - xout, yout: the result of the procedure
;
; Keywords:
;  - x0: where in 'x' to symmetrize the data (default: 0.0)
;
pro symmetrize, xdata, ydata, xout, yout, x0=x0
    if ~keyword_set(x0) then x0 = 0.0
    
    idn = where(xdata le x0, nneg)
    xout = fltarr(2*nneg-1)
    yout = fltarr(2*nneg-1)
    
    xout[idn] = xdata[idn]
    yout[idn] = ydata[idn]
    
    idn = idn[lindgen(nneg-1)]
    idp = idn + nneg
    xout[idp] = 2.0*x0 - reverse(xdata[idn])
    yout[idp] = reverse(ydata[idn])
end
