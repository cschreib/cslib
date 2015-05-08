; Computes the 'perc'th percentile over the 'y_data' (sorted) data set
function percentile, y_data, perc, no_sort=no_sort, dimension=dimension
    if ~provided(dimension) then begin
        if keyword_set(no_sort) then begin
            return, y_data[(n_elements(y_data)-1)*perc]
        endif else begin
            idf = where(finite(y_data), cnt)
            if cnt eq 0 then return, !values.f_nan
            ids = idf[sort(y_data[idf])]
            return, y_data[ids[(n_elements(idf)-1)*perc]]
        endelse
    endif else begin
        ds = size(y_data, /dimensions) & d = n_elements(ds)
        if dimension gt d then begin
            message, 'error: dimension can only range from 1 to '+strn(d)+' for this array'
        endif

        mpitch_before = 1 & mpitch_after = 1
        for i=0, dimension-2 do mpitch_after *= ds[i]
        for i=dimension, d-1 do mpitch_before *= ds[i]

        npt = mpitch_after*mpitch_before

        res = replicate(y_data[0], npt)
        idb = (indgen(npt) mod mpitch_after) + (indgen(npt)/mpitch_after)*mpitch_after*ds[dimension-1]
        for i=0, npt-1 do begin
            res[i] = percentile(y_data[idb[i] + indgen(ds[dimension-1])*mpitch_after], perc)
        endfor

        return, res
    endelse
end
