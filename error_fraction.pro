function error_fraction, numbers, nsigma=nsigma
    if n_elements(nsigma) eq 0 then nsigma = 1.0

    tot = total(numbers)
    t = nsigma^2/tot
    p0 = numbers/tot

    p = (p0 + t/2.0)/(1.0 + t)
    pe = sqrt(p0*(1.0-p0)*t + t^2/4.0)/(1.0 + t)

    result = fltarr(n_elements(numbers), 3)
    result[*,0] = p - pe
    result[*,1] = p0
    result[*,2] = p + pe

    return, result
end
