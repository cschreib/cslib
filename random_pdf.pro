; Generate a set of randomn numbers based of the provided probability distribution function.
;
; Arguments:
;  - seed: the 'seed' to use to generate uniformly distributed randomn numbers (uses 'randomu')
;  - pdfx, pdfy: the PSF (value and its probability), it will be linearly interpolated
;  - nsrc: the number of values to generate
function random_pdf, seed, pdfx, pdfy, nsrc
    tmp = dindgen(n_elements(pdfy), n_elements(pdfy))
    cpdf = pdfy # (tmp ge transpose(tmp))
    cpdf /= cpdf[n_elements(cpdf)-1]

    return, interpol(pdfx, cpdf, randomu(seed, nsrc, /double))
end
