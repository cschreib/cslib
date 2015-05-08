; Convert a time value to a string in 'ddhhmmss' format
function timing_fmt, time
    if time lt 0 then return, '??s'
    d = long(floor(time/(60.0*60.0*24.0)))
    h = long(floor(time/(60.0*60.0))) - d*24
    m = long(floor(time/(60.0))) - (d*24 + h)*60
    s = long(floor(time)) - ((d*24 + h)*60 + m)*60
    
    if d eq 0 then begin
        if h eq 0 then begin
            if m eq 0 then begin
                ss = strn(s)
                return, ss+"s"
            endif else begin
                sm = strn(m)
                ss = strn(s, length=2, padchar='0')
                return, sm+"m"+ss+"s"
            endelse
        endif else begin
            sh = strn(h)
            sm = strn(m, length=2, padchar='0')
            ss = strn(s, length=2, padchar='0')
            return, sh+"h"+sm+"m"+ss+"s"
        endelse
    endif else begin
        sd = strn(d)
        sh = strn(h, length=2, padchar='0')
        sm = strn(m, length=2, padchar='0')
        ss = strn(s, length=2, padchar='0')
        return, sd+"d"+sh+"h"+sm+"m"+ss+"s"
    endelse
end
