pro printradec, file, ra, dec
    openw, lun, file, /get_lun
    for i=0L, n_elements(ra)-1 do printf, lun, ra[i], dec[i], format='(2F15.8)'
    free_lun, lun
end
