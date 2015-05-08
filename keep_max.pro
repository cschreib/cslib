; Builds a new array keeping only the greatest values between the two data sets.
function keep_max, d1, d2
    n1 = n_elements(d1)
    n2 = n_elements(d2)
    if n1 ge n2 then begin
        ma = d1
        for i=0, n2-1 do ma[i] = max([d1[i], d2[i]])
    endif else begin
        ma = d2
        for i=0, n1-1 do ma[i] = max([d1[i], d2[i]])
    endelse
    return, ma
end
