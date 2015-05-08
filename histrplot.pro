pro histrplot, data, sel, _extra=extra, bins=bins, xdata=xdata, ydata=ydata, nodata=nodata, $
    yrange=yrange, xrange=xrange, percent=percent, fill=fill

    ohistplot, data, _extra=extra, bins=bins, xdata=xdata, ydata=ydata, /nodata
    ohistplot, data, weight=sel, bins=bins, /usebins, ydata=ysdata, /nodata

    idnz = where(ydata ne 0, cnt)
    if cnt ne 0 then ydata[idnz] = ysdata[idnz]/double(ydata[idnz])
    if keyword_set(percent) then ydata *= 100.0

    if ~provided(yrange) then yrange = [0, max(ydata)]
    if ~provided(xrange) then xrange = [min(xdata), max(xdata)]

    plot, /nodata, _extra=extra, xrange=xrange, yrange=yrange, [0,1]

    if ~keyword_set(nodata) then begin
        if keyword_set(fill) then begin
            histplot_fill, xdata, ydata, _extra=extra
        endif
        oplot, xdata, ydata, _extra=extra
    endif
end
