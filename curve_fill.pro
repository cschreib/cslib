; Fills the area below, above, leftwards or rightwards of a curve.
;
; Arguments:
;  - xdata, ydata: the curve
;
; Keywords:
;  - histogram: set this flag if the curve is an histogram (with square edges)
;  - left,right,top,bottom: control what area to fill (default: bottom)
;  - color: the color to use to fill the area (default: !p.color)
;  - spacing: if style is > 0, control the distance between strips
;  - style:
;     0: plain color (default)
;     1: +45° strips
;     2: -45° strips
;     3: horizontal strips
;
pro curve_fill, xdata, ydata, color=color, style=style, spacing=spacing, $
    left=left, right=right, top=top, bottom=bottom, clim=clim

    if ~keyword_set(left) and ~keyword_set(right) and ~keyword_set(top) then bottom=1

    if keyword_set(bottom) or keyword_set(top) then begin
        txdata = xdata
        tydata = ydata
    endif else begin
        txdata = ydata
        tydata = xdata
    endelse

    nbin = n_elements(txdata)
    xpoly = replicate(txdata[0], (nbin-1)*6)
    if keyword_set(bottom) or keyword_set(left) then begin
        ypoly = replicate(min(tydata), (nbin-1)*6)
    endif else begin
        ypoly = replicate(max(tydata), (nbin-1)*6)
    endelse

    for b=0L, nbin-2 do begin
        xpoly[b*6+0] = txdata[b]
        xpoly[b*6+1] = txdata[b]
        xpoly[b*6+2] = txdata[b+1]
        xpoly[b*6+3] = txdata[b+1]
        xpoly[b*6+4] = txdata[b+1]
        xpoly[b*6+5] = txdata[b]

        ypoly[b*6+1] = tydata[b]
        ypoly[b*6+2] = tydata[b+1]
        ypoly[b*6+3] = tydata[b+1]
    endfor

    if ~keyword_set(bottom) and ~keyword_set(top) then begin
        tmp = xpoly
        xpoly = ypoly
        ypoly = tmp
    endif

    if ~provided(style) then style = 0

    case style of
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

    polyfill, xpoly, ypoly, color=color, line_fill=line_fill, orientation=orientation, $
        spacing=spacing, noclip=0
end
