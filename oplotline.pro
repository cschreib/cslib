; Overplot a single line
;
; Arguments:
;  - slope: [optional] the slope of the line (1.0 : 1:1 correlation, 0.0 : no correlation, defaults
;           to 1.0)
;  - offset: [optional] the offset of the line (defaults to 0.0)
;
pro oplotline, slope, offset, fill=fill, fstyle=fstyle, fcolor=fcolor, color=color, _extra=pextra
    if ~provided(slope) then slope = 1.0
    if ~provided(offset) then offset = 0.0

    if ~finite(slope) then begin
        if !x.type eq 0 then xdata = [offset, offset] else xdata = [offset, offset]
        if !y.type eq 0 then ydata = !y.crange else ydata = 10d0^(!y.crange)
    endif else begin
        if !x.type eq 0 then xdata = !x.crange else xdata = 10d0^(!x.crange)
        if !y.type eq 0 then ydata = slope*xdata + offset else ydata = (10d0^offset)*xdata^slope
    endelse

    if provided(fill) then begin
        if fill gt 0 then begin
            xpoly = [xdata[0], xdata[1], xdata[1], xdata[0]]
            if !y.type eq 1 then begin
                ypoly = [ydata[0], ydata[1], 10d0^(max(!y.crange)), 10d0^(max(!y.crange))]
            endif else begin
                ypoly = [ydata[0], ydata[1], max(!y.crange), max(!y.crange)]
            endelse
        endif else if fill lt 0 then begin
            xpoly = [xdata[0], xdata[1], xdata[1], xdata[0]]
            if !y.type eq 1 then begin
                ypoly = [ydata[0], ydata[1], 10d0^(min(!y.crange)), 10d0^(min(!y.crange))]
            endif else begin
                ypoly = [ydata[0], ydata[1], min(!y.crange), min(!y.crange)]
            endelse
        endif

        if fill ne 0 then begin
            xma = max(!x.crange) & xmi = min(!x.crange)
            yma = max(!y.crange) & ymi = min(!y.crange)
            if !x.type eq 1 then begin
                xmi = 10d0^xmi
                xma = 10d0^xma
            endif
            if !y.type eq 1 then begin
                ymi = 10d0^ymi
                yma = 10d0^yma
            endif
            xpoly = clamp(xpoly, xmi, xma)
            ypoly = clamp(ypoly, ymi, yma)

            if ~provided(fstyle) then fstyle = 0
            if ~provided(fcolor) and provided(color) then fcolor = color

            case fstyle of
            0: begin
                line_fill = 0
            end
            1: begin
                line_fill = 1
                orientation = 45.0
            end
            2: begin
                line_fill = 1
                orientation = -45.0
            end
            3: begin
                line_fill = 1
            end
            endcase

            if line_fill then begin
                polyfill, xpoly, ypoly, color=fcolor, /line_fill, orientation=orientation
            endif else begin
                polyfill, xpoly, ypoly, color=fcolor
            endelse
        endif
    endif

    oplot, xdata, ydata, color=color, _extra=pextra
end
