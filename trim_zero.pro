function trim_zero, value
    if n_elements(value) gt 1 then begin
        res = make_array(size=size(value), type=7)
        for i=0, n_elements(value)-1 do begin
            res[i] = trim_zero(value[i])
        endfor
        return, res
    endif

    if value eq '0' then return, value

    str = byte(value)
    n = strlen(value)

    if strpos(value, '.') eq -1 then begin
        ie = strlen(value)
    endif else begin
        i = n-1
        while i gt 0 do if str[i] eq byte('0') then i-- else break
        if str[i] eq byte('.') then i--

        ie = i+1
    endelse

    i = 0
    if str[i] eq byte('-') or str[i] eq byte('+') then begin
        sign = string(str[i])
        i++
    endif else begin
        sign = ''
    endelse

    while i lt n do if str[i] eq byte('0') then i++ else break
    if i eq n then return, sign+'0'
    if str[i] eq byte('.') then i--

    return, sign+strmid(string(str), i, ie)
end
