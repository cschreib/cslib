; Build bins according to the provided parameters.
;
; Arguments:
;  - data: the data to analyse
;
; Keywords:
;  - numbins: specify the number of bins to create (default : 10)
;  - linearbins: set this flag to use linearly spaced bins instead of constant population bins
;  - bins: out data containing the bins
;  - maxsample: maximum size of a bin (used when 'linearbins' is not set)
;  - range: minimum and maximum values to use to create the bin (default: from sample)
;
pro makebins, tdata, numbins=numbins, linearbins=linearbins, bins=bins, maxsample=maxsample, $
    range=range

    idf = where(finite(tdata), cnt)
    if cnt eq 0 then begin
        message, 'error: no finite color data in this sample'
    endif
    data = tdata[idf]

    nfixed = 1
    if ~provided(numbins) then begin
        numbins = 10L
        nfixed = 0
    endif

    if keyword_set(linearbins) then begin
        if provided(range) then begin
            mi = range[0]
            ma = range[1]
            step = (ma - mi)/double(numbins)
        endif else if n_elements(linearbins) eq 2 then begin
            mi = linearbins[0]
            ma = linearbins[1]
            step = (ma - mi)/double(numbins)
        endif else if n_elements(linearbins) eq 3 then begin
            mi = linearbins[0]
            ma = linearbins[1]
            step = linearbins[2]
            numbins = (ma - mi)/step
        endif else begin
            mi = min(data) - 0.001
            ma = max(data) + 0.001
            step = (ma - mi)/double(numbins)
        endelse
    endif else begin
        if provided(range) then begin
            idin = where(data ge min(range) and data le max(range), cnt)
            if cnt eq 0 then begin
                message, 'error: no finite color data in this sample'
            endif

            tsid = sort(data[idin])
            if range[0] gt range[1] then tsid = reverse(tsid)
            sorted_ids = idin[tsid]
        endif else begin
            sorted_ids = sort(data)
        endelse

        uid = uniq(data, sorted_ids)
        udat = data[uid]

        dxup = n_elements(udat)/numbins

        if n_elements(udat) le numbins then begin
            numbins = n_elements(udat)
        endif else if provided(maxsample) then begin
            firstid = 0L & xid = 0L
            xup = n_elements(data)/numbins
            lastb = data[sorted_ids[0]]
            numbins = 0
            while xid lt n_elements(data) do begin
                if xid eq xup-1 or data[sorted_ids[xid]] - lastb gt maxsample then begin
                    lastb = data[sorted_ids[xid]] + 0.001
                    ++numbins
                    xup = xup + dxup
                endif
                ++xid
            endwhile
        endif
    endelse

    bins = {low:dblarr(numbins), up:dblarr(numbins)}

    if keyword_set(linearbins) then begin
        bins.low = step*dindgen(numbins) + mi
        bins.up = step*(dindgen(numbins)+1.0D) + mi
    endif else begin
        if n_elements(udat) eq numbins then begin
            if n_elements(udat) eq 1 then begin
                bins.low = double(udat) - 0.5
                bins.up = double(udat) + 0.5
            endif else begin
                for i=0L, numbins-1L do begin
                    td = abs(double(udat[i]) - udat)
                    tdid = sort(td)
                    bins.low[i] = double(udat[i]) - td[tdid[1]]/2.0
                    bins.up[i] = double(udat[i]) + td[tdid[1]]/2.0
                endfor
            endelse
        endif else begin
            xid = 0L & b = 0L
            xup = dxup
            lastb = udat[0]

            while xid lt n_elements(udat) do begin
                if keyword_set(maxsample) then begin
                    split = (xid eq xup-1 or (udat[xid] - lastb) gt maxsample)
                endif else begin
                    split = (xid eq xup-1)
                endelse

                if split then begin
                    bins.low[b] = lastb
                    bins.up[b] = udat[xid] + 0.001
                    lastb = bins.up[b]

                    ++b
                    if b eq numbins-1 then begin
                        xup = n_elements(udat)
                    endif else begin
                        xup = xup + dxup
                    endelse
                endif
                ++xid
            endwhile

            numbins = b
            bins = {low:bins.low[indgen(b)], up:bins.up[indgen(b)]}
        endelse
    endelse
end
