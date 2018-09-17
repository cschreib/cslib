function cumul, v, reverse=reverse
    t = v

    if keyword_set(reverse) then begin
        t[n_elements(v)-1] = 0
        for i=0, n_elements(v)-2 do t[i] = total(v[i:*])
    endif else begin
        t[0] = 0
        for i=1, n_elements(v)-1 do t[i] = total(v[0:i])
    endelse

    return, t
end
