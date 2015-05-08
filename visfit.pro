pro visfit, expr, fx, fy, fye, start_params=start_params, params=params, $
    nofit=nofit, fix=fix, perr=perr, _extra=extra
    if keyword_set(nofit) then p = start_params else begin
        if provided(fix) then begin
            free = {fixed:0}
            frozen = free & frozen.fixed = 1
            pinfo = replicate(free, n_elements(start_params))
            for i=0, n_elements(start_params)-1 do if fix[i] then pinfo[i] = frozen
        endif

        p = mpfitexpr(expr, fx, fy, fye, start_params, perror=perror, parinfo=pinfo, /quiet)
    endelse

    errplot, fx, fy-fye, fy+fye
    plot, fx, fy, _extra=extra
    idf = where(finite(fx) and finite(fy))
    x = rgen(min(fx[idf]), max(fx[idf]), 1000)
    void = execute('y = '+expr)
    oplot, x, y, col='ff'x
    params = p
end
