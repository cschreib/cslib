; Finds values that are present in both provided data sets (assuming that each data set contains
; no duplicates).
;
; Arguments:
;  - data1: the first data set
;  - data2: the second data set
;  - cnt: [optional, output] number of matches
;
function find_matches, data1, data2, count
    n1 = n_elements(data1)
    n2 = n_elements(data2)
    if n2 lt n1 then begin
        res = find_matches(data2, data1, count)
        return, {ids1:res.ids2, ids2:res.ids1}
    endif
    
    matches1 = lonarr(n1)
    matches2 = lonarr(n1)
    count = 0L
    
    for i=0L, n1-1 do begin
        ids = where(data2 eq data1[i], num_match)
        if num_match eq 0 then continue
        
        matches1[count] = i
        matches2[count] = ids[0]
        ++count
    endfor
    
    if count eq 0 then return, {ids1:-1L, ids2:-1L}
    
    return, {ids1:matches1[lindgen(count)], ids2:matches2[lindgen(count)]}
end
