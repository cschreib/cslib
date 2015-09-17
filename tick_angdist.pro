function tick_angdist, axis, index, value
    ; value is in arcsec
    sign = 1
    if value lt 0 then begin
        sign = -1
        value = -value
    endif

    sec = value mod 60
    min = long((value - sec) mod 3600)/60
    hour = long(value - sec - min*60)/3600

    txt = trim_zero(strn(sec))+'"'
    if min ne 0 or hour ne 0 then txt = strn(min)+"'"+txt
    if hour ne 0 then txt = strn(hour)+'h'+txt

    if sign eq -1 then txt = '-'+txt

    return, txt
end
