; Converts right ascension and declination in degrees to sexagesimal coordinates.
;
; Return:
;  - [ra, dec]: values in sexagesimal (string hh:mm:ss)
;
; Arguments:
;  - ra, dec: values in degrees
;
function radectosex, tra, tdec
    rp = tra lt 0
    ra = abs(tra)
    rah = long(floor(ra/15.0))
    ram = long(floor((ra/15.0 - rah)*60))
    ras = ((ra/15.0 - rah)*60 - ram)*60

    dp = tdec lt 0
    dec = abs(tdec)
    dech = long(floor(dec))
    decm = long(floor((dec - dech)*60))
    decs = ((dec - dech)*60 - decm)*60

    sm = strna(ram)
    idl = where(ram lt 10, cnt)
    if cnt ne 0 then sm[idl] = '0'+sm[idl]
    ss = strna(ras, format='(f7.4)')
    idl = where(ras lt 10, cnt)
    if cnt ne 0 then ss[idl] = '0'+ss[idl]
    idz = where(ras lt 1e-4, cnt)
    if cnt ne 0 then ss[idz] = '00.0000'

    sra = strna(rah)+':'+sm+':'+ss
    idp = where(rp, cntp)
    if cntp ne 0 then sra[idp] = '-'+sra[idp]


    sm = strna(decm)
    idl = where(decm lt 10, cnt)
    if cnt ne 0 then sm[idl] = '0'+sm[idl]
    ss = strna(decs, format='(f7.4)')
    idl = where(decs lt 10, cnt)
    if cnt ne 0 then ss[idl] = '0'+ss[idl]
    idz = where(decs lt 1e-4, cnt)
    if cnt ne 0 then ss[idz] = '00.0000'

    sdec = strna(dech)+':'+sm+':'+ss
    idp = where(dp, cntp)
    if cntp ne 0 then sdec[idp] = '-'+sdec[idp]

    if n_elements(ra) eq 1 then return, [sra[0], sdec[0]]
    return, [[sra], [sdec]]
end

