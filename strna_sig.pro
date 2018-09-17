function strna_sig, vals, num
    ret = replicate('', n_elements(vals))
    for i=0, n_elements(vals)-1 do ret[i] = strn_sig(vals[i], num)
    return, ret
end
