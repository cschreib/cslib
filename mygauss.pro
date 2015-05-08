; A simple gaussian distribution.
;
; Arguments:
;  - xdata: the array of positions at which to compute the gaussian distribution
;  - params: array containing the gaussian normalization, the deviation and the center respectively.
;
function mygauss, xdata, params
    return, params[0]*exp(-(xdata - params[2])^2/(2.0*params[1]^2))
end

