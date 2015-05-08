function tex_percent, f, ndec=ndec
    if n_elements(f) gt 1 then begin
        res = strarr(n_elements(f))
        for ii=0, n_elements(f)-1 do res[ii] = tex_percent(f[ii], ndec=ndec)
    endif else begin
        if ~keyword_set(ndec) then ndec = 2
        n2 = strn(ndec, format='(I20)')
        n1 = strn(ndec+1+3, format='(I20)')
        return, '$'+strn(f,format='(F'+n1+'.'+n2+')')+'\,\%$'
    endelse

    return, res
end
