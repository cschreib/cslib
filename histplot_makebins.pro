; Build the data necessary to plot an histogram.
;
; Arguments:
;  - dat: the data to analyse
;  - xdata: [output] the x data that will be plotted
;  - ydata: [output] the y data that will be plotted
;
; Keywords:
;  - weight: array of weights to give to each element of the data set
;  - numbins: specify the number of bins to use to sample the data (default : 10)
;  - intbins: set this flag to constrain the bins to be centered on integers and with a width of 1
;  - continuous: set this flag to plot the counts using a continuous curve instead of an histogram
;  - normalized: set this flag to divide the counts by the number of elements in the data set
;  - bins: [input/output] the bins used by this procedure
;  - usebins: set this flag to make the procedure use the provided 'bins'
;
pro histplot_makebins, dat, xdata, ydata, xmin=xmin, xmax=xmax, bins=bins, numbins=numbins, $
    usebins=usebins, continuous=continuous, intbins=intbins, normalized=normalized, cumul=cumul, $
    weight=weight, errors=errors, count_limit=count_limit, perbin=perbin

    if n_elements(weight) eq 1 then begin
        tweight = replicate(weight, n_elements(dat))
    endif else if ~provided(weight) then begin
        tweight = replicate(1.0, n_elements(dat))
    endif else begin
        tweight = weight
    endelse

    okids = where(finite(dat) and finite(tweight), cnt) ; filter nan and infinite values
    if cnt eq 0 then return

    tldat = dat[okids]

    if provided(xmin) then tmpmin = xmin else tmpmin = min(tldat)
    if provided(xmax) then tmpmax = xmax else tmpmax = max(tldat)
    if ~provided(cumul) then cumul = 0
    if ~provided(count_limit) then count_limit = 0

    idok = where(finite(dat) and finite(tweight) and dat ge tmpmin and dat le tmpmax, cnt)
    if cnt eq 0 then return
    ldat = dat[idok]

    tweight = tweight[idok]

    if keyword_set(usebins) then begin
        numbins = n_elements(bins.low)
    endif else begin
        if keyword_set(intbins) then begin
            datmin = round(tmpmin) - 0.5
            datmax = round(tmpmax) - 0.5
            numbins = ceil(datmax - datmin) + 1
            step = 1.0
        end else begin
            datmin = tmpmin
            datmax = tmpmax
            if ~provided(numbins) then numbins = 10
            step = float(datmax - datmin)/numbins
        endelse
        bins = {low:fltarr(numbins), up:fltarr(numbins)}
        for b=0L, numbins-1 do begin
            bins.low[b] = datmin + b*step
            bins.up[b]  = datmin + (b+1)*step
        endfor
    endelse

    if keyword_set(continuous) then begin
        xdata = replicate(!values.f_nan, numbins)
        ydata = replicate(0.0d, numbins)
    endif else begin
        xdata = replicate(!values.f_nan, 2*numbins + 2)
        ydata = replicate(0.0d, 2*numbins + 2)
    endelse

    if arg_present(errors) then errors = replicate(!values.f_nan, numbins)

    if keyword_set(continuous) then begin
        for b=0L, numbins-1 do begin
            xdata[b] = (bins.low[b] + bins.up[b])/2.0
            if cumul eq 1 then begin
                ids = where(ldat ge bins.low[0] and ldat lt bins.up[b], count)
            endif else if cumul eq -1 then begin
                ids = where(ldat ge bins.low[b] and ldat lt bins.up[n_elements(bins.up)-1], count)
            endif else begin
                ids = where(ldat ge bins.low[b] and ldat lt bins.up[b], count)
            endelse

            if count gt count_limit then begin
                if arg_present(errors) then begin
                    errors[b] = sqrt(total(tweight[ids]^2))
                endif
                ydata[b] = total(tweight[ids])
            endif
        endfor
    endif else begin
        xdata[0] = bins.low[0]
        ydata[0] = 0.0

        for b=0L, numbins-1 do begin
            xdata[2*b+1] = bins.low[b]
            xdata[2*b+2] = bins.up[b]

            if cumul eq 1 then begin
                if b eq numbins-1 then begin
                    ids = where(ldat ge bins.low[0] and ldat le bins.up[b], count)
                endif else begin
                    ids = where(ldat ge bins.low[0] and ldat lt bins.up[b], count)
                endelse
            endif else if cumul eq -1 then begin
                if b eq numbins-1 then begin
                    ids = where(ldat ge bins.low[b] and ldat le bins.up[n_elements(bins.up)-1], count)
                endif else begin
                    ids = where(ldat ge bins.low[b] and ldat lt bins.up[n_elements(bins.up)-1], count)
                endelse
            endif else begin
                if b eq numbins-1 then begin
                    ids = where(ldat ge bins.low[b] and ldat le bins.up[b], count)
                endif else begin
                    ids = where(ldat ge bins.low[b] and ldat lt bins.up[b], count)
                endelse
            endelse

            if count gt count_limit then begin
                if arg_present(errors) then begin
                    errors[b] = sqrt(total(tweight[ids]^2))
                endif

                factor = 1.0
                if provided(perbin) then begin
                    if size(perbin, /type) ge 1 and size(perbin, /type) le 3 then begin
                        if perbin ne 0 then begin
                            factor = (bins.up[b] - bins.low[b])
                        endif
                    endif else if size(perbin, /type) eq 7 then begin
                        void = execute('factor = '+perbin+'(bins.low[b], bins.up[b])')
                    endif else begin
                        message, 'unexpected type for "perbin" keyword, need string or integer'
                    endelse
                endif

                count = total(tweight[ids])/factor
                ydata[2*b+1] = count
                ydata[2*b+2] = count
            endif
        endfor

        xdata[2*numbins+1] = bins.up[numbins-1]
        ydata[2*numbins+1] = 0.0
    endelse

    if keyword_set(normalized) then ydata = ydata/total(tweight)
end
