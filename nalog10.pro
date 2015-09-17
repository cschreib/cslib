function nalog10, x
    if n_elements(x) gt 1 then begin
        idz = where(x ge 0, cnt, comp=idlz)
        res = x*0
        res[idz] = alog10(x[idz]+1)
        res[idlz] = -alog10(-x[idlz]+1)
        return, res
    endif else begin
        if x ge 0 then return, alog10(x+1) else return, -alog10(-x+1)
    endelse
end
