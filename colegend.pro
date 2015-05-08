; Display a color legend using the bins created by 'colplot' or 'ocolplot'.
;
; Arguments:
;  - bins: color bins as output from 'colplot' or 'ocolplot'
;  - range: set this keyword if 'bins' comes from 'binplot' or 'plot2d'
;  - top, bottom: set one of these keywords to position the title of the legend
;  - titpos: set this keyword to the output of 'bake_legend' for better title position if 'bottom'
;            is set
;  - llog: use logarithmic scale for legend axis
;
; Keywords:
;  - + all keywords available to 'contour'
;
pro colegend, bins, range=range, xstyle=xstyle, xtickformat=xtickformat, top=top, bottom=bottom, $
    xtit=xtit, position=position, charsize=charsize, titpos=titpos, llog=llog, _extra=extra
    if ~provided(xstyle) then xstyle = 1
    if ~keyword_set(bottom) then begin
        cxstyle = xstyle
        xstyle = 8 or xstyle
        xtickformat = '(A1)'
        if provided(xtit) then begin
            ctit = xtit
            xtit = ''
        endif
    endif

    if keyword_set(range) then begin
        data = (bins.range[1] - bins.range[0])*findgen(255)/254.0 + bins.range[0]
        if keyword_set(llog) then data = alog10(data)
        plot2d, transpose(areplicate(data,1)), imgyrange=[0,1], levels=bins, /uselevels, $
            imgxrange=bins.range, xtit=xtit, xstyle=xstyle, xtickformat=xtickformat, ytickformat='(A1)', $
            ytickinterval=1.0, yticks=1, yminor=1, position=position, charsize=charsize, _extra=extra
    endif else begin
        xr = [min(bins.low), max(bins.up)]
        if bins.low[1] - bins.low[0] lt 0 then xr = reverse(xr)
        plot, bins.low, bins.low, xr=xr, xstyle=xstyle, yr=[0,1], ytickinterval=1.0, $
            xtit=xtit, xtickformat=xtickformat, ytickname=[' ',' '], $
            yticks=1, yminor=1, position=position, charsize=charsize, xlog=llog, _extra=extra

        nbin = n_elements(bins.low)
        for i=0, nbin-1 do begin
            polyfill, [bins.low[i], bins.up[i], bins.up[i], bins.low[i]], [0,0,1,1], $
                noclip=0, col=bins.color[i]
        endfor

        plot, bins.low, bins.low, /nodata, /noerase, xr=xr, xstyle=xstyle, yr=[0,1], ytickinterval=1.0, $
            xtit=xtit, xtickformat=xtickformat, ytickname=[' ',' '], $
            yticks=1, yminor=1, position=position, charsize=charsize, xlog=llog, _extra=extra

        ; col = bins.color
        ; cdata = fltarr(n_elements(bins.low)+1, 2)
        ; cdata[0,*] = [bins.low[0], bins.low[0]]
        ; cdata[lindgen(n_elements(bins.low))+1,*] = [bins.up, bins.up]

        ; xdata = cdata[*,0]
        ; ydata = [0,1]

        ; stop
        ; if xdata[1] - xdata[0] lt 0 then begin
        ;     xdata = reverse(xdata)
        ;     ydata = reverse(ydata)
        ;     cdata = reverse(cdata)
        ;     col = reverse(col)
        ; endif

        ; contour, cdata, xdata, ydata, levels=xdata, nlevel=n_elements(col), /cell_fill, c_colors=col, $
        ;     ytickinterval=1.0, xtit=xtit, xstyle=xstyle, xtickformat=xtickformat, ytickname=[' ',' '], $
        ;     yticks=1, yminor=1, position=position, charsize=charsize, xlog=llog, _extra=extra
    endelse

    if ~keyword_set(bottom) then begin
        if ~provided(ctit) then begin
            axis, xaxis=1, xstyle=cxstyle, charsize=charsize, _extra=extra
        endif else begin
            if ~provided(titpos) then begin
                axis, xaxis=1, xstyle=cxstyle, charsize=charsize, xtit=ctit, _extra=extra
            endif else begin
                axis, xaxis=1, xstyle=cxstyle, charsize=charsize, _extra=extra
                xyouts, (!x.window[1] + !x.window[0])/2, titpos, /normal, alignment=0.5, charsize=charsize, ctit
            endelse
        endelse
    endif
end
