function tex_int, ti
    if n_elements(ti) gt 1 then begin
        res = strarr(n_elements(ti))
        for ii=0, n_elements(ti)-1 do res[ii] = tex_int(ti[ii])
    endif else begin
        i = long(ti)
        if i eq 0 then return, '0'
        res = ''
        neg = 0
        if i lt 0 then begin
            neg = 1
            i = -i
        endif

        while i ne 0 do begin
            im = i mod 1000
            i /= 1000
            chunk = strn(im, format='(I4)')
            if i ne 0 then begin
                while strlen(chunk) lt 3 do chunk = '0'+chunk
                chunk = '\ ' + chunk
            endif
            res = chunk + res
        endwhile
        if neg then res = '-'+res
        return, '$'+res+'$'
    endelse

    return, res
end
