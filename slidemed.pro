; Computes the sliding median and percentiles over an arbitrary data set
;
; Arguments:
;  - x_data, y_data: data to work on
;
; Keywords:
;  - num_pts: the number of points to generate sliding data
;  - sample_size: the sample to work on for each slice (in % of the total width)
;  - perc: the high percentile (i.e. 0.9 for the 90'th percentile)
;  - min_sample: the minimum sample size for each slice
;  - xr: range in X within which to restrict the median computation
;
function slidemed, x_data, y_data, num_pts=num_pts, sample_size=sample_size, perc=perc, $
    min_sample=min_sample, xr=xr, nbstrap=nbstrap, seed=seed

    gid = where(finite(x_data) and finite(y_data))

    if ~provided(xr) then xr = [min(x_data[gid]), max(x_data[gid])]
    xr = double(xr)
    width = xr[1] - xr[0]

    if ~provided(num_pts) then num_pts = 100
    if ~provided(sample_size) then sample_size = 1.0/num_pts
    if ~provided(perc) then perc = 0.84
    if ~provided(min_sample) then min_sample = 0

    sample = sample_size*width
    step = width/(num_pts - 1.0)

    med  = fltarr(num_pts)
    nsrc  = lonarr(num_pts)
    low  = fltarr(num_pts)
    up   = fltarr(num_pts)
    xtab = rgen(xr[0], xr[1], num_pts)

    for i=0, num_pts-1 do begin
        ; Build the local sample
        local_ids = where(abs(x_data[gid] - xtab[i]) le sample, cnt)
        if cnt le min_sample then begin
            if min_sample eq 0 then begin
                med[i] = !values.f_nan
                up[i] = !values.f_nan
                low[i] = !values.f_nan
                continue
            endif

            local_sample = sample
            while n_elements(local_ids) le min_sample do begin
                if local_sample ge width then break
                local_sample = local_sample*1.05
                local_ids = where(abs(x_data[gid] - xtab[i]) le local_sample)
            endwhile
            if n_elements(local_ids) le min_sample then break
        endif

        local_ids = gid[local_ids]

        ; Compute the median
        sorted = local_ids[sort(y_data[local_ids])]
        med[i] = percentile(y_data[sorted], 0.5, /no_sort)
        nsrc[i] = n_elements(local_ids)

        if n_elements(nbstrap) eq 0 then begin
            ; Compute percentiles
            low[i] = percentile(y_data[sorted], 1.0 - perc, /no_sort)
            up[i]  = percentile(y_data[sorted], perc, /no_sort)
        endif else begin
            ; Bootstrap to get uncertainty on median
            tmed = fltarr(nbstrap)
            for j=0, nbstrap-1 do begin
                sid = shuffle(sorted, num_ids=n_elements(sorted)/2, seed=seed)
                tmed[j] = percentile(y_data[sid], 0.5, /no_sort)
            endfor

            ssid = sort(tmed)
            tmed = tmed[ssid]
            low[i] = (percentile(tmed, 1.0 - perc, /no_sort) - med[i])/sqrt(2) + med[i]
            up[i] = (percentile(tmed, perc, /no_sort) - med[i])/sqrt(2) + med[i]
        endelse
    endfor

    return, {x:xtab, med:med, low:low, up:up, nsrc:nsrc}
end
