pro band_shade, x, y, horizontal=horizontal, color=color, style=style
    nb = n_elements(x)/2
    if ~provided(color) then tcolor = color_invert(!p.background) else tcolor = color
    if ~provided(style) then tstyle = 0 else tstyle = style
    if n_elements(tcolor) lt nb then tcolor = [tcolor, replicate(tcolor[n_elements(tcolor)-1], nb - n_elements(tcolor))]
    if n_elements(tstyle) lt nb then tstyle = [tstyle, replicate(tstyle[n_elements(tstyle)-1], nb - n_elements(tstyle))]

    line_fill = intarr(nb)
    orientation = fltarr(nb)
    for i=0, nb-1 do begin
        case tstyle[i] of
        0: begin
            line_fill[i] = 0
        end
        1: begin
            line_fill[i] = 1
            orientation[i] = 45.0
        end
        2: begin
            line_fill[i] = 1
            orientation[i] = -45.0
        end
        3: begin
            line_fill[i] = 1
        end
        endcase
    endfor

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

    if n_elements(y) eq 2 then begin
        ymi = y[0]
        yma = y[1]
    endif

    if keyword_set(horizontal) then begin
        xpoly = [xmi, xma, xma, xmi]

        for i=0, nb-1 do begin
            ypoly = clamp(x[2*i + [0,0,1,1]], ymi, yma)
            if line_fill[i] then begin
                polyfill, xpoly, ypoly, color=tcolor[i], /line_fill, orientation=orientation[i]
            endif else begin
                polyfill, xpoly, ypoly, color=tcolor[i]
            endelse
        endfor
    endif else begin
        ypoly = [ymi, yma, yma, ymi]

        for i=0, nb-1 do begin
            xpoly = clamp(x[2*i + [0,0,1,1]], xmi, xma)
            if line_fill[i] then begin
                polyfill, xpoly, ypoly, color=tcolor[i], /line_fill, orientation=orientation[i]
            endif else begin
                polyfill, xpoly, ypoly, color=tcolor[i]
            endelse
        endfor
    endelse
end
