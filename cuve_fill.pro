; Fills the area below, above, leftwards or rightwards of a curve.
;
; Arguments:
;  - xdata, ydata: the curve
;
; Keywords:
;  - histogram: set this flag if the curve is an histogram (with square edges)
;  - left,right,top,bottom: control what area to fill (default: bottom)
;  - fcolor: the color to use to fill the area (default: !p.color)
;  - fspacing: if fstyle is > 0, control the distance between strips
;  - fstyle:
;     0: plain color (default)
;     1: +45° strips
;     2: -45° strips
;     3: horizontal strips
;
pro curve_fill, xdata, ydata, fcolor=fcolor, fstyle=fstyle, fspacing=fspacing, $
    left=left, right=right, top=top, bottom=bottom, histogram=histogram

    if keyword_set(histogram) then begin
        nbin = n_elements(xdata)/2 - 1
        xpoly = replicate(xdata[0],   nbin*6)
        ypoly = replicate(min(ydata), nbin*6)

        for b=0L, nbin-1 do begin
            xpoly[b*6+0] = xdata[2*b+1]
            xpoly[b*6+1] = xdata[2*b+1]
            xpoly[b*6+2] = xdata[2*b+2]
            xpoly[b*6+3] = xdata[2*b+2]
            xpoly[b*6+4] = xdata[2*b+2]
            xpoly[b*6+5] = xdata[2*b+1]

            ypoly[b*6+1] = ydata[2*b+1]
            ypoly[b*6+2] = ydata[2*b+1]
            ypoly[b*6+3] = ydata[2*b+1]
        endfor
    endif else begin
        nbin = n_elements(xdata)
        xpoly = replicate(xdata[0],   (nbin-1)*6)
        ypoly = replicate(min(ydata), (nbin-1)*6)

        for b=0L, nbin-2 do begin
            xpoly[b*6+0] = xdata[b]
            xpoly[b*6+1] = xdata[b]
            xpoly[b*6+2] = xdata[b+1]
            xpoly[b*6+3] = xdata[b+1]
            xpoly[b*6+4] = xdata[b+1]
            xpoly[b*6+5] = xdata[b]

            ypoly[b*6+1] = ydata[b]
            ypoly[b*6+2] = ydata[b+1]
            ypoly[b*6+3] = ydata[b+1]
        endfor
    endelse

    ; xma = max(!x.crange) & xmi = min(!x.crange)
    ; yma = max(!y.crange) & ymi = min(!y.crange)
    ; if !x.type eq 1 then begin
    ;     xmi = 10d0^xmi
    ;     xma = 10d0^xma
    ; endif
    ; if !y.type eq 1 then begin
    ;     ymi = 10d0^ymi
    ;     yma = 10d0^yma
    ; endif
    ; xpoly = clamp(xpoly, xmi, xma)
    ; ypoly = clamp(ypoly, ymi, yma)

    if ~provided(fstyle) then fstyle = 0

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
        polyfill, xpoly, ypoly, color=fcolor, /line_fill, orientation=orientation, spacing=fspacing, $
            noclip=0
    endif else begin
        polyfill, xpoly, ypoly, color=fcolor, spacing=fspacing, noclip=0
    endelse
end
