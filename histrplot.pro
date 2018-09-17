pro histrplot, data, sel, _extra=extra, bins=bins, xdata=xdata, ydata=ydata, nodata=nodata, $
    yrange=yrange, xrange=xrange, xlog=xlog, percent=percent, fill=fill, cumul=cumul, $
    continuous=continuous, normalize=normalize

    ohistplot, data, _extra=extra, xlog=xlog, bins=bins, xdata=xdata, ydata=ydata, /nodata, $
        cumul=cumul, continuous=continuous
    ohistplot, data, weight=sel, xlog=xlog, bins=bins, /usebins, ydata=ysdata, /nodata, $
        cumul=cumul, continuous=continuous

    idnz = where(ydata ne 0, cnt)
    if cnt ne 0 then ydata[idnz] = ysdata[idnz]/double(ydata[idnz])

    if keyword_set(normalize) and provided(cumul) then begin
        if cumul eq 1 then ydata /= ydata[n_elements(ydata)-1]
        if cumul eq -1 then ydata /= ydata[0]
    endif

    if keyword_set(percent) then ydata *= 100.0

    if ~provided(yrange) then yrange = [0, max(ydata)]
    if ~provided(xrange) then xrange = [min(xdata), max(xdata)]

    plot, /nodata, _extra=extra, xlog=xlog, xrange=xrange, yrange=yrange, [0,1]

    if keyword_set(xlog) then xdata = 10d0^xdata

    if ~keyword_set(nodata) then begin
        if keyword_set(fill) then begin
            histplot_fill, xdata, ydata, _extra=extra
        endif
        oplot, xdata, ydata, _extra=extra
    endif
end
