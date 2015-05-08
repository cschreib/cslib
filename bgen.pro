function bgen, x0, x1, nbin, log=log
    if keyword_set(log) then begin
        tx0 = alog10(x0)
        tx1 = alog10(x1)
    endif else begin
        tx0 = x0
        tx1 = x1
    endelse
    
    dx = (x1 - x0)/nbin
    
    return, {low:lindgen(nbin)*dx + x0, up:(lindgen(nbin)+1)*dx + x0}
end
