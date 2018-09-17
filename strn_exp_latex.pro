function strn_exp_latex, val, sig
    if val eq 0 then return, '0'

    aval = floor(alog10(abs(val)))
    if aval eq 0 then return, strn_sig(val, sig)

    tval = val/10d0^aval
    return, '$'+strn_sig(tval, sig)+'\times10^{'+strn(aval)+'}$'
end
