; Replicates an array.
; This function is a simplified version of 'cmreplicate' that only works for 1D arrays.
;
; Arguments:
;  - array: the array to duplicate
;  - num: the number of times to duplicate the array
;
; Keyword:
;  - transpose: set this keyword to produce a 'n x num' array instead of 'num x n'
;
function areplicate, array, num, transpose=transpose
    n = n_elements(array)
    if size(array, /type) eq 7 then begin
        ; Special case for string
        bt = byte(flatten(array))
        btd = size(bt, /dim)
        if n_elements(btd) eq 1 then btd = [btd[0], 1]
        nc = btd[0]
        ns = btd[1]
        ret = string(rebin(bt, nc, ns, num))

        if keyword_set(transpose) then begin
            return, ret
        endif else begin
            return, transpose(ret)
        endelse
    endif else begin
        ret = reform(rebin(array, n*num, /sample), num, n)

        if keyword_set(transpose) then begin
            return, transpose(ret)
        endif else begin
            return, ret
        endelse
    endelse
end
