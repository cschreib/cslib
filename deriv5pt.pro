function deriv5pt, dx, y
    as0 = [-25.0/12.0, 4.0,     -3.0,      4.0/3.0, -1.0/4.0]
    as1 = [-1.0/4.0,  -5.0/6.0,  3.0/2.0, -1.0/2.0,  1.0/12.0]
    a   = [1.0/12.0,  -2.0/3.0,  0.0,      2.0/3.0, -1.0/12.0]
    af1 = [-1.0/12.0,  1.0/2.0, -3.0/2.0,  5.0/6.0,  1.0/4.0]
    af0 = [1.0/4.0,   -4.0/3.0,  3.0,     -4.0,      25.0/12.0]

    if n_elements(dx) ne 1 then begin
        message, 'error: first argument must be the step in X (Y must be linearly sampled in X)'
    endif
    n = n_elements(y)
    if n lt 5 then begin
        message, 'error: not enough points to derivate (need 5 at least)'
    endif

    res = y

    res[0] = as0[0]*y[0] + as0[1]*y[1] + as0[2]*y[2] + as0[3]*y[3] + as0[4]*y[4]
    res[1] = as1[0]*y[0] + as1[1]*y[1] + as1[2]*y[2] + as1[3]*y[3] + as1[4]*y[4]

    res[2:n-3] = a[0]*y[0:n-5] + a[1]*y[1:n-4] + a[3]*y[3:n-2] + a[4]*y[4:n-1]

    res[n-2] = af1[0]*y[n-5] + af1[1]*y[n-4] + af1[2]*y[n-3] + af1[3]*y[n-2] + af1[4]*y[n-1]
    res[n-1] = af0[0]*y[n-5] + af0[1]*y[n-4] + af0[2]*y[n-3] + af0[3]*y[n-2] + af0[4]*y[n-1]

    res /= dx

    return, res
end
