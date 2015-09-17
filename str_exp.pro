function str_exp, value
    if n_elements(value) gt 1 then begin
        res = strarr(n_elements(value))
        for ii=0, n_elements(value)-1 do res[ii] = str_exp(value[ii])
        return, res
    endif else begin
        if value eq '0' or strpos(value, 'E') eq -1 then return, value

        p = strpos(value, 'E')
        r = trim_zero(strmid(value, 0, p))
        e = trim_zero(strmid(value, p+1))
        if (byte(e))[0] eq byte('+') then e = strmid(e, 1)

        if e ne '0' then e = ' x 10!u'+e+'!n' else e = ''

        return, r+e
    endelse
end
