; Plots the histogram of a data set.
;
; Arguments:
;  - dat: the data to analyse
;
; Keywords:
;  - weight: array of weights to give to each element of the data set
;  - numbins: specify the number of bins to use to sample the data (default: see 'histplot_makebins')
;  - intbins: set this flag to constrain the bins to be centered on integers and with a width of 1
;  - continuous: set this flag to plot the counts using a continuous curve instead of an histogram
;  - normalized: set this flag to divide the counts by the number of elements in the data set
;  - bins: [input/output] the bins used by this procedure
;  - usebins: set this flag to make the procedure use the provided 'bins'
;  - xdata: [output] the x data that was just plotted
;  - ydata: [output] the y data that was just plotted
;  - fill: set this keyword to fill the area below the histogram
;  - fstyle, fcolor: see 'histplot_fill'
;  - + all keywords available to 'plot'
;
function histplot_prob, dat, prob, bins=bins, weight=weight
    if keyword_set(xlog) then begin
        tmpdat = alog10(dat)
        if provided(xmax) then txmax = alog10(xmax)
        if provided(xmin) then txmin = alog10(xmin)
    endif else begin
        tmpdat = dat
        if provided(xmax) then txmax = xmax
        if provided(xmin) then txmin = xmin
    endelse

    histplot_makebins, tmpdat, xdata, ydata, xmin=txmin, xmax=txmax, bins=bins, cumul=cumul, $
        numbins=numbins, usebins=usebins, continuous=continuous, intbins=intbins, $
        normalized=normalized, weight=weight, errors=errors

    if n_elements(xdata) eq 0 then begin
        if keyword_set(nodata) then begin
            ; Dummy value, not used
            xdata = [0, 1]
            ydata = [0, 1]
        endif else begin
            message, 'error: histplot: invalid data set (no finite value)'
        endelse
    endif

    if keyword_set(ylog) and ~provided(yr) then begin
        if keyword_set(normalized) or provided(weight) then begin
            idnz = where(ydata gt 0.0d, cnt)
            if cnt eq 0 then yr=[0.1, 1.0] else yr = [min(ydata[idnz]), max(ydata)]
        endif else begin
            yr = [1,max(ydata)]
        endelse
    endif

    if keyword_set(xlog) then tmpxdata = 10d0^xdata else tmpxdata = xdata

    plot, tmpxdata, ydata, yr=yr, xlog=xlog, ylog=ylog, _extra=plotextra, /nodata
    if keyword_set(nodata) then return

    if ~provided(fcolor) and provided(color) then fcolor = color
    if keyword_set(fill) then begin
        histplot_fill, tmpxdata, ydata, continuous=continuous, fstyle=fstyle, fcolor=fcolor, $
            fspacing=fspacing
    endif

    oplot, tmpxdata, ydata, color=color, _extra=plotextra
end
