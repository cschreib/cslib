function strzerofill, v, n
    if n_elements(v) gt 1 then begin
        tmp = strarr(n_elements(v))
        for i=0, n_elements(v)-1 do tmp[i] = strzerofill(v[i], n)
    endif else begin
        tmp = strn(v)
        tmp = strrepeat('0',long(alog10(n-1))+1 - strlen(tmp))+tmp
    endelse
    return, tmp
end
