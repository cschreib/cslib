pro myticks, xaxis=xaxis, yaxis=yaxis, xdtick=xdtick, xticklen=xticklen, xthick=xthick, $
                                       ydtick=ydtick, yticklen=yticklen, ythick=ythick, $
                                       color=color

    if n_elements(xticklen) eq 0 then begin
        if !x.ticklen eq 0 then xticklen = !p.ticklen else xticklen = !x.ticklen
    endif
    if n_elements(yticklen) eq 0 then begin
        if !y.ticklen eq 0 then yticklen = !p.ticklen else yticklen = !y.ticklen
    endif
    if n_elements(color) eq 0 then color = !p.color

    if n_elements(xaxis) ne 0 then begin
        if xaxis eq 0 then yp = !y.crange[0]+[0,(!y.crange[1]-!y.crange[0])*xticklen]
        if xaxis eq 1 then yp = !y.crange[1]-[0,(!y.crange[1]-!y.crange[0])*xticklen]
        if xaxis gt 1 or xaxis lt 0 then message, 'invalid value for xaxis, need 0 or 1'

        x0 = xdtick*ceil(!x.crange[0]/xdtick) & x1 = xdtick*floor(!x.crange[1]/xdtick)
        if x0 eq !x.crange[0] then x0 += xdtick

        ntick = (x1 - x0)/xdtick
        for k=0, ntick-1 do begin
            oplot, [0,0]+x0+k*xdtick, yp, thick=xthick, color=color
        endfor
    endif

    if n_elements(yaxis) ne 0 then begin
        if yaxis eq 0 then xp = !x.crange[0]+[0,(!x.crange[1]-!x.crange[0])*yticklen]
        if yaxis eq 1 then xp = !x.crange[1]-[0,(!x.crange[1]-!x.crange[0])*yticklen]
        if yaxis gt 1 or yaxis lt 0 then message, 'invalid value for yaxis, need 0 or 1'

        y0 = ydtick*ceil(!y.crange[0]/ydtick) & y1 = ydtick*floor(!y.crange[1]/ydtick)
        if y0 eq !y.crange[0] then y0 += ydtick

        ntick = (y1 - y0)/ydtick
        for k=0, ntick-1 do begin
            oplot, xp, [0,0]+y0+k*ydtick, thick=ythick, color=color
        endfor
    endif
end
