; Builds a new array keeping only the smallest values between the two data sets
function keep_min, d1, d2
    n1 = n_elements(d1)
    n2 = n_elements(d2)
    if n1 ge n2 then begin
        mi = d1
        for i=0, n2-1 do mi[i] = min([d1[i], d2[i]])
    endif else begin
        mi = d2
        for i=0, n1-1 do mi[i] = min([d1[i], d2[i]])
    endelse
    return, mi
end
