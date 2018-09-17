function match_wcs, src, src_hdr, dst, dst_hdr, transposed=transposed
    res = dst*!values.f_nan
    ndx = n_elements(res[*,0])
    ndy = n_elements(res[0,*])
    nsx = n_elements(src[*,0])
    nsy = n_elements(src[0,*])

    x = areplicate(dindgen(ndx), ndy, /transpose)
    y = areplicate(dindgen(ndy), ndx)

    ; x -= 0.5
    ; y -= 0.5

    if size(src_hdr, /type) eq 7 then extast, src_hdr, src_ast else src_ast = src_hdr
    if size(dst_hdr, /type) eq 7 then extast, dst_hdr, dst_ast else dst_ast = dst_hdr

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
