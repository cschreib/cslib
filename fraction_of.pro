function fraction_of, x, among=among, percent=percent
    if provided(among) then begin
        res = total(among and x)/total(among)
    endif else begin
        res = total(x)/n_elements(x)
    endelse

    if keyword_set(percent) then begin
        return, strn(round(1000*res)/10.0, format='(F4.1)')+'%'
    endif else begin
        return, res
    endelse
end
