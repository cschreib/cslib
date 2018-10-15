function cumul, v, reverse=reverse
    if keyword_set(reverse) then begin
        return, total(reverse(v), /cumulative)
    endif else begin
        return, total(v, /cumulative)
    endelse
end
