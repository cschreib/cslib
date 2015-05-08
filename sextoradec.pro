; Converts sexagesimal coordinates to right ascension and declination in degrees.
;
; Return:
;  [ra, dec]: values in degrees
;
; Arguments:
;  - rah, ram, ras: sexagesimal values for the right ascension
;  - dech, decm, decs: sexagesimal values for the declination
;
; or:
;  - ra, dec: sexagesimal strings 'hh:mm:ss'
;
function sextoradec, rah, ram, ras, dech, decm, decs
    if n_params() eq 2 then begin
        starr1 = strsplit(rah, ':', /extract)
        starr2 = strsplit(ram, ':', /extract)
        
        rah = long(starr1[0])
        ram = long(starr1[1])
        ras = double(starr1[2])
        
        dech = long(starr2[0])
        decm = long(starr2[1])
        decs = double(starr2[2])
    endif
    
    nelem = n_elements(rah)
    if nelem eq 1 then begin
        signr = 1.0D
        if rah lt 0.0 then signr = -1.0D
        
        signd = 1.0D
        if dech lt 0.0 then signd = -1.0D
    endif else begin
        signr = replicate(1.0D, n_elements(rah))
        id = where(rah lt 0.0, cnt)
        if cnt gt 0 then signr[id] = -1.0D
        
        signd = replicate(1.0D, n_elements(rah))
        id = where(dech lt 0.0, cnt)
        if cnt gt 0 then signd[id] = -1.0D
    endelse
    
    ra = (rah + ram*signr/60.0D + ras*signr/3600.0D)*15.0D
    dec = dech + decm*signd/60.0D + decs*signd/3600.0D
    
    return, [ra, dec]
end

