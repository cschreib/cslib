; Build the distribution of the provided data set using the given bins
; This is almost like an histogram, the only difference is that the number of values that fall in
; each bin is divided by the width of the bin and by the total amount of values.
; By construction, the integral of this distribution is one (if the provided bins cover the entire
; sample).
function make_distrib, data, bins=bins, error=error
    nb = n_elements(bins.low)
    dist = dblarr(nb)
    if arg_present(error) then error = dblarr(nb)
    for b=0, nb-1 do begin
        idl = where(data ge bins.low[b] and data lt bins.up[b], cnt)
        if cnt ne 0 then begin
            weight = 1.0/((bins.up[b] - bins.low[b])*n_elements(data))
            dist[b] = cnt*weight
            if arg_present(error) then error[b] = sqrt(cnt+1)*weight
        endif
    endfor

    return, dist
end
