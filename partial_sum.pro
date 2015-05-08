function partial_sum, x
    r = x
    r[*] = 0
    for i=1, n_elements(x)-1 do begin
        r[i] = r[i-1] + x[i]
    endfor
end
