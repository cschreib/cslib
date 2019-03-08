; Computes the 'perc'th percentile over the 'y_data' (sorted) data set
function percentile, y_data, perc, no_sort=no_sort, dimension=dimension
    ds = size(y_data, /dimensions) & d = n_elements(ds)

    if ~provided(dimension) or d eq 1 then begin
        if keyword_set(no_sort) then begin
            return, y_data[(n_elements(y_data)-1)*perc]
        endif else begin
            idf = where(finite(y_data), cnt)
            if cnt eq 0 then return, !values.f_nan
            ids = idf[sort(y_data[idf])]
            return, y_data[ids[(n_elements(idf)-1)*perc]]
        endelse
    endif else begin
        if dimension gt d then begin
            message, 'error: dimension can only range from 1 to '+strn(d)+' for this array'
        endif

        if dimension eq 1 then begin
            nds = ds[1:*]
        endif else if dimension eq n_elements(ds) then begin
            nds = ds[0:dimension-2]
        endif else begin
            nds = [ds[0:dimension-2], ds[dimension:*]]
        endelse

        mpitch = 1
        for i=0, dimension-2 do mpitch *= ds[i]

        res = replicate(y_data[0], nds)

        for i=0, n_elements(res)-1 do begin
            stride = (i mod mpitch) + (i/mpitch)*ds[dimension-1]*mpitch
            tmp = y_data[stride + lindgen(ds[dimension-1])*mpitch]
            res[i] = percentile(tmp, perc)
        endfor

        return, res
    endelse
end
