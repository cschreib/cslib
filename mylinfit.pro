; Simple analytic fitting of a straight line (a + b*x) in a data set.
;
; Return:
;  An array containing the constant offset and the slope of the fit respectively.
;
; Arguments:
;  - x, y: the data to fit
;  - ye: [optional] errors on 'y' (if absent, 1.0 is assumed for all points)
;
; Keywords:
;  - slope: fix the slope of the line
;  - xr: range in 'x' to limit the study
;  - err: [output] standard errors on the fitting parameters (offset and slope respectively)
;  - bisector: [flag] perform fit on x/y and y/x then return the bisector best fit (does not take
;              errors into account, and does not return errors on the best fit)
;
function mylinfit, x, y, ye, slope=slope, xr=xr, err=err, bisector=bisector
    if ~provided(ye) then ye = y*0 + 1

    if keyword_set(bisector) then begin
        p0 = mylinfit(x, y)
        p1 = mylinfit(y, x)
        s0 = p0[1] & s1 = 1.0/p1[1]
        slope = (s0*s1 - 1.0 + sqrt((1.0 + s0^2)*(1.0 + s1^2)))/(s0 + s1)
        a = p0[0] + (p0[0]*p1[1] + p1[0])/(1 - p0[1]*p1[1])*(p0[1] - slope)
        return, [a, slope]
    endif

    if provided(xr) then begin
        xsel = where(xr[0] le x and x lt xr[1])
        dx = double(x[xsel])
        dy = double(y[xsel])
        dye = double(ye[xsel])
    endif else begin
        xsel = where(finite(x))
        dx = double(x[xsel])
        dy = double(y[xsel])
        dye = double(ye[xsel])
    endelse

    dye = dye^2

    if ~provided(slope) then begin
        s = total(1.0/dye)
        sx = total(dx/dye)
        sy = total(dy/dye)
        sxx = total(dx^2/dye)
        sxy = total(dx*dy/dye)

        delta = s*sxx - sx^2
        a = (sxx*sy - sx*sxy)/delta
        b = (s*sxy - sx*sy)/delta

        if arg_present(err) then begin
            err = [sqrt(sxx/delta), sqrt(s/delta)]
        endif

        return, [a, b]
    endif else begin
        s = total(1.0/dye)
        sx = total(dx/dye)
        sy = total(dy/dye)

        a = (sy - slope*sx)/s

        if arg_present(err) then begin
            err = [sqrt(1.0/s), 0.0]
        endif

        return, [a, slope]
    endelse
end
