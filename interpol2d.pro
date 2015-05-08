pro interpol2d_bake_, x, v, i1, i2, d
    n = n_elements(x)

    iv = interpol(findgen(n), x, v)

    i1 = 0 > floor(iv) < (n-2)
    i2 = i1+1
    d = iv - i1
end

function interpol2d, y, x1, x2, tv1, tv2, _extra=extra
    n1 = n_elements(x1)
    n2 = n_elements(x2)
    if n_elements(y[*,0]) ne n1 or n_elements(y[0,*]) ne n2 then begin
        message, 'error: Y array dimensions does not match X1 and X2'
    endif

    v1 = tv1
    v2 = tv2

    nv1 = n_elements(v1)
    nv2 = n_elements(v2)
    if nv1 eq 1 and nv2 gt 1 then v1 = replicate(v1[0], nv2)
    if nv2 eq 1 and nv1 gt 1 then v2 = replicate(v2[0], nv1)
    nv1 = n_elements(v1)
    nv2 = n_elements(v2)

    if nv1 ne nv2 then begin
        message, 'error: V2 array dimensions does not match V1'
    endif

    interpol2d_bake_, x1, v1, i11, i12, d1
    interpol2d_bake_, x2, v2, i21, i22, d2

    return, (1.0-d1)*(1.0-d2)*y[i11,i21] + d1*(1.0-d2)*y[i12,i21] + $
        (1.0-d1)*d2*y[i11,i22] + d1*d2*y[i12,i22]
end
