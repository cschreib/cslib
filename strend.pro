; Return 'true' if the provided string ends with a given pattern
function strend, str, pattern
    if n_elements(str) gt 1 then begin
        res = bytarr(n_elements(str))
        for i=0, n_elements(str)-1 do begin
            res[i] = strend(str[i], pattern)
        endfor
        return, res
    endif else begin
        if strlen(str) lt strlen(pattern) then return, byte(0)
        return, strmid(str, strlen(str)-strlen(pattern), strlen(pattern)) eq pattern
    endelse
end
