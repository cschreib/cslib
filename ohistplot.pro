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
;  - + all keywords available to 'oplot'
;
pro ohistplot, dat, xlog=xlog, xmin=xmin, xmax=xmax, xdata=xdata, ydata=ydata, nodata=nodata, $
    numbins=numbins, bins=bins, usebins=usebins, continuous=continuous, normalized=normalized, $
    intbins=intbins, weight=weight, errors=errors, fill=fill, fstyle=fstyle, fcolor=fcolor, $
    fspacing=fspacing, color=color, cumul=cumul, count_limit=count_limit, perbin=perbin, $
    _extra=oplotextra

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
        normalized=normalized, weight=weight, errors=errors, count_limit=count_limit, $
        perbin=perbin

    if n_elements(xdata) eq 0 then return

    if keyword_set(nodata) then return

    if keyword_set(xlog) then tmpxdata = 10d0^xdata else tmpxdata = xdata

    tmpydata = ydata
    if !y.type eq 1 then begin
        idz = where(ydata eq 0, cnt)
        if cnt ne 0 then begin
            tmpydata[idz] = 0.1*min(10d0^(!y.crange))
        endif
    endif

    if ~provided(fcolor) and provided(color) then fcolor = color
    if keyword_set(fill) then begin
        histplot_fill, tmpxdata, tmpydata, continuous=continuous, fstyle=fstyle, fcolor=fcolor, $
            fspacing=fspacing
    endif

    oplot, tmpxdata, tmpydata, color=color, _extra=oplotextra
end
