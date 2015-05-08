; Remove one or more elements from an array, one by one, starting from the largest ids.
; Note that this function doesn't make any asumption on the elements that are to be removed. For 
; example: if the elements are contiguous, there is much faster way to remove them than what this
; function does.
;
; Arguments:
;  - dat: the data set you want to remove elements from
;  - ids: the ids of the elements you want to remove (in any order)
;
function erase, dat, ids
    if n_elements(ids) eq 1 then begin
        n = n_elements(dat)
        case index OF
            0   : return, dat[1:*]
            n-1 : return, dat[0:n-2]
            else: return, [dat[0:ids-1], dat[ids+1:n-1] ]
        endcase
    endif else begin
        cdat = dat
        ids = ids[uniq(ids, sort(ids))]
        for i=0, n_elements(ids)-1 do begin
            cdat = erase(cdat, ids[n_elements(ids)-1-i])
        endfor
        return, cdat
    endelse
end
