function tex_float, f
    if n_elements(f) gt 1 then begin
        res = strarr(n_elements(f))
        for ii=0, n_elements(f)-1 do res[ii] = tex_float(f[ii])
        return, res
    endif else begin
        if f eq '0' or strpos(f, 'E') eq -1 then return, f

        p = strpos(f, 'E')
        r = trim_zero(strmid(f, 0, p))
        e = trim_zero(strmid(f, p+1))
        if (byte(e))[0] eq byte('+') then e = strmid(e, 1)

        if e ne '0' then e = ' 10^{'+e+'}' else e = ''

        return, '$'+r+e+'$'
    endelse
end
