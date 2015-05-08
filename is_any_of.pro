function is_any_of, x, y
    res = intarr(n_elements(x))
    for i=0, n_elements(y)-1 do begin
        res = res or (x eq y[i])
    endfor
    return, res
end
