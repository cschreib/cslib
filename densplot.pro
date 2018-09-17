; Plots a 2D histogram for the provided data set
;
; Arguments:
;  - x: 'x' value of each element
;  - y: 'y' value of each element
;
; Keywords:
;  - numbins: specify the number of bins in each axis ('x' and 'y' respectively, or both if a single
;             value is provided)
;  - xr: defines the minimum and maximum values to consider for the 'x' axis (default: [min, max])
;  - yr: defines the minimum and maximum values to consider for the 'y' axis (default: [min, max])
;  - log: set this keyword to plot the distribution in logarithmic scale
;  - smooth: if non zero, will smooth out every bin of the map by a circular kernel or radius
;            'smooth' (in number of bins). Warning: can be slow.
;  - normalized: set this keyword to generate a normalized distribution (each value is divided by
;                the total number of elements in the data set)
;  - dmap: [output] the density map that is plotted
;  - + all keywords available to 'plot2d'
;
pro densplot, x, y, numbins=numbins, xr=xr, yr=yr, log=log, smooth=smooth, normalized=normalized, $
        dmap=dmap, weight=weight, levels=levels, legend=legend, lbottom=lbottom, ltop=ltop, lwidth=lwidth, $
        position=position, ctitle=ctitle, charsize=charsize, noerase=noerase, lextra=lextra, $
        _extra=cextra

    dmap = density_map(x, y, numbins=numbins, smooth=smooth, normalized=normalized, weight=weight, xr=xr, yr=yr)
    if keyword_set(log) then dmap = alog10(dmap + 1)

    if keyword_set(legend) then begin
        bleg = bake_legend(top=ltop, bottom=lbottom, width=lwidth, title=provided(ctitle))
        mppos = bleg.plot_pos
        bppos = bleg.leg_pos
        tppos = bleg.tit_pos

        if provided(charsize) then lcs = charsize
        if provided(lextra) then begin
            wcs = where(tag_names(lextra) eq 'CHARSIZE', cnt)
            if cnt ne 0 then lcs = lextra.(wcs[0])
        endif

        op = !p
        plot2d, dmap, levels=levels, noerase=noerase, /noplot, _extra=cextra
        colegend, levels, /range, position=bppos, xtit=ctitle, bottom=lbottom, top=ltop, $
            charsize=charsize, titpos=tppos, noerase=noerase, _extra=lextra
        !p = op

        noerase = 1
    endif else if provided(position) then mppos = position

    plot2d, dmap, imgxrange=xr, imgyrange=yr, levels=levels, position=mppos, $
        noerase=noerase, _extra=cextra
end
