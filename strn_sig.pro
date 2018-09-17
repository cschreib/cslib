function strn_sig, val, num, format=format
    if val eq 0 then begin
        format = '(I1)'
        return, '0'
    endif

    aval = floor(alog10(abs(val)))
    expo = num-aval-1
    if expo le 0 then begin
        format = '(I18)'
        return, strn(long(val))
    endif

    tval = round(val*10d0^expo)/10d0^expo

    format = '(F'+strn(18+1+expo)+'.'+strn(expo)+')'
    return, strn(tval, format=format)
end
