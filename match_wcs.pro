function match_wcs, src, src_hdr, dst, dst_hdr
    res = dst*!values.f_nan
    ndx = n_elements(res[*,0])
    ndy = n_elements(res[0,*])
    nsx = n_elements(src[*,0])
    nsy = n_elements(src[0,*])

    x = areplicate(dindgen(ndx), ndy, /transpose)
    y = areplicate(dindgen(ndy), ndx)

    ; x -= 0.5
    ; y -= 0.5

    extast, src_hdr, src_ast
    extast, dst_hdr, dst_ast

    xy2ad, x, y, dst_ast, r, d
    ad2xy, r, d, src_ast, x, y

    ; x += 0.5
    ; y += 0.5
    x = round(x)
    y = round(y)

    idg = where(x gt 0 and x lt nsx and y gt 0 and y lt nsy)
    res[idg] = src[x[idg], y[idg]]

    return, res
end
