; Finds values of the first data set that are not present in the second data set (assuming that
; each data set contains no duplicates).
;
; Arguments:
;  - data1: the first data set
;  - data2: the second data set
;  - count: [optional, output] number of non matches
;
function find_non_matches, data1, data2, count
    n1 = n_elements(data1)
    matches = lonarr(n1)
    count = 0L
    
    for i=0L, n1-1 do begin
        ids = where(data2 eq data1[i], cnt)
        if cnt eq 0 then begin
            matches[count] = i
            ++count
        endif
    endfor
    
    if count eq 0 then return, -1
    return, matches[lindgen(count)]
end
