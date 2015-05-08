; Finds duplicated values in a data set and return their ids.
;
; Arguments:
;  - data: the data set in which to search for duplicates
;  - numdup: [optional, output] the number of duplicates 
;
; Keywords:
;  - sorted_in: set this flag if the provided data is already sorted
;  - sorted_out: set this flag if you want the output to be sorted
;
function find_duplicates, data, numdup, sorted_in=sorted_in, sorted_out=sorted_out
    ndat = n_elements(data)
    if keyword_set(sorted_in) then begin
        sorted_ids = lindgen(ndat)
    endif else begin
        sorted_ids = sort(data)
    endelse
    
    dups = lonarr(ndat)
    numdup = 0L
    last_dat = data[sorted_ids[0]]
    first = 1
    
    for i=1L, ndat-1L do begin
        new_dat = data[sorted_ids[i]]
        if new_dat gt last_dat then begin
            first = 1
            last_dat = new_dat
            continue
        endif
        
        if first then begin
            dups[numdup+0] = sorted_ids[i-1]
            dups[numdup+1] = sorted_ids[i]
            numdup = numdup+2
            first = 0
        endif else begin
            dups[numdup] = sorted_ids[i]
            ++numdup
        endelse
    endfor
    
    if numdup eq 0 then return, -1
    dups = dups[lindgen(numdup)]
    if keyword_set(sorted_out) then dups = dups[sort(dups)]
    return, dups
end
