function median_sed, flux, ids, snr=snr, err=err, counts=counts
    nb = n_elements(flux[*,0])
    sed = fltarr(nb)*!values.f_nan
    if arg_present(snr) then snr = fltarr(nb)*!values.f_nan
    if arg_present(counts) then counts = lonarr(nb)
    for b=0, nb-1 do begin
        tid = where(flux[b,ids] gt 0, cnt)
        if cnt eq 0 then continue

        if arg_present(counts) then counts[b] = cnt

        sed[b] = median(flux[b,ids[tid]])
        if arg_present(snr) then begin
            snr[b] = median(flux[b,ids[tid]]/err[b,ids[tid]])
        endif
    endfor

    return, sed
end
