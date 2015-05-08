; Counts the number of values that are present in both provided data sets
;
; Arguments:
;  - data1: the first data set
;  - data2: the second data set
;
function count_matches, data1, data2
    n1 = n_elements(data1)
    n2 = n_elements(data2)
    count = 0L
    
    if n1 lt n2 then begin
        for i=0L, n1-1L do begin
            ids = where(data2 eq data1[i], cnt)
            count = count + cnt
        endfor
    endif else begin
        for i=0L, n2-1L do begin
            ids = where(data1 eq data2[i], cnt)
            count = count + cnt
        endfor
    endelse
    
    return, count
end
