pro plot_slidemed, xdata, ydata, reverse=reverse, _extra=pextra
    if keyword_set(reverse) then begin
        sm = slidemed(ydata, xdata)

        oplot, sm.med, sm.x, color=color, _extra=pextra
        oplot, sm.low, sm.x, color=color, linestyle=1, _extra=pextra
        oplot, sm.up, sm.x, color=color, linestyle=1, _extra=pextra
    endif else begin
        sm = slidemed(xdata, ydata)

        oplot, sm.x, sm.med, color=color, _extra=pextra
        oplot, sm.x, sm.low, color=color, linestyle=1, _extra=pextra
        oplot, sm.x, sm.up, color=color, linestyle=1, _extra=pextra
    endelse
end
