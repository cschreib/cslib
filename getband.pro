; Find a band ID in a catalog
;  - cat: the catalog (read from FITS file)
;  - band: string to find in the band name
;  - note: [optional] string to find in the band note
;
function getband, cat, band, note=note
    if n_elements(band) gt 1 then begin
        ids = lonarr(n_elements(band))
        for i=0, n_elements(band)-1 do ids[i] = getband(cat, band[i], note=note)
        return, ids
    endif else begin
        bpos = strpos(strtrim(string(cat.bands)), band)

        if n_elements(note) eq 0 then begin
            ids = where(bpos ne -1, cnt)
            if cnt eq 0 then print, 'error: no band matching "'+band+'"'
            if cnt gt 1 then begin
                idpm = where(bpos eq 0 and strlen(string(cat.bands)) eq strlen(band), cntp)
                if cntp ne 1 then begin
                    print, 'error: multiple bands matching "'+band+'"'
                    if cntp eq 0 then begin
                        for i=0, cnt-1 do begin
                            print, '  candidate: band='+(string(cat.bands))[ids[i]]
                        endfor
                    endif
                    return, -1
                endif
                ids = idpm
            endif
        endif else begin
            npos = strpos(strtrim(string(cat.notes)), note)
            ids = where(bpos ne -1 and npos ne -1, cnt)
            if cnt eq 0 then print, 'error: no band matching "'+band+'" and "'+note+'"'

            if cnt gt 1 then begin
                idpm = where((bpos eq 0 and strlen(string(cat.bands)) eq strlen(band)) and $
                             (npos eq 0 and strlen(string(cat.notes)) eq strlen(note)), cntp)
                if cntp ne 1 then begin
                    print, 'error: multiple bands matching "'+band+'" and "'+note+'"'
                    for i=0, cnt-1 do begin
                        print, '  candidate: band='+(string(cat.bands))[ids[i]]+', note='+(string(cat.notes))[ids[i]]
                    endfor
                    return, -1
                endif
                ids = idpm
            endif
        endelse

        return, ids[0]
    endelse
end
