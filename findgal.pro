function findgal, ra1, dec1, ra2, dec2, beam=beam, dlist=dlist, first=first
    gcirc, 2, ra1, dec1, ra2, dec2, dd
    sorted_dd_id = sort(dd)
    
    if provided(beam) then begin
        idb = where(dd[sorted_dd_id] le beam, cnt)
        if cnt eq 0 then return, -1
        if arg_present(dlist) then dlist = dd[sorted_dd_id[idb]]
        return, sorted_dd_id[idb]
    endif else begin
        if provided(first) then begin
            if arg_present(dlist) then dlist = dd[sorted_dd_id[0:first]]
            return, sorted_dd_id[0:first]
        endif else begin
            if arg_present(dlist) then dlist = dd[sorted_dd_id[0]]
            return, sorted_dd_id[0]
        endelse
    endelse
end
