function strn_error_latex, val, err_low, err_up
    if ~finite(val) then return, '---'

    elow = -err_low < err_up

    sig = 1
    if elow/10d0^(floor(alog10(elow))) lt 4 then sig = 2

    void = strn_sig(elow, sig, format=fmt)
    serr_up = strn(err_up, format=fmt)
    serr_low = strn(err_low, format=fmt)
    sval = strn(val, format=fmt)

    return, '$'+sval+'^{+'+serr_up+'}_{'+serr_low+'}$'
end
