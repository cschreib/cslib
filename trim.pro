function trim, str, char, back=back
    chars = byte(char)
    bstr = byte(str)
    nc = n_elements(chars)

    i = strlen(str)
    found = 1
    while i gt 0 and found do begin
        i--
        found = 0
        for j=0, nc-1 do begin
            if bstr[i] eq chars[j] then begin
                found = 1
                break
            endif
        endfor
    endwhile

    if i eq 0 and found then return, ''

    i1 = i

    if ~keyword_set(back) then begin
        i = -1
        found = 1
        while i lt i1 and found do begin
            i++
            found = 0
            for j=0, nc-1 do begin
                if bstr[i] eq chars[j] then begin
                    found = 1
                    break
                endif
            endfor
        endwhile
    endif else begin
        i = 0
    endelse

    return, strmid(str, i, 1+i1-i)
end
