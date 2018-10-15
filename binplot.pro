; Plots a 2D binned mean for the provided 3D data set
;
; Arguments:
;  - x: 'x' value of each element
;  - y: 'y' value of each element
;  - z: 'z' value of each element
;
; Keywords:
;  - numbins: specify the number of bins in each axis ('x' and 'y' respectively, or both if a single
;             value is provided)
;  - xr: defines the minimum and maximum values to consider for the 'x' axis (default: [min, max])
;  - yr: defines the minimum and maximum values to consider for the 'y' axis (default: [min, max])
;  - zlog: set this keyword to plot the mean in logarithmic scale
;  - median: set this keywords to compute the median rather than the mean of the 'z' values
;  - dmap: [output] the density map that is plotted
;  - + all keywords available to 'plot2d'
;
pro binplot, x, y, z, numbins=numbins, xr=xr, yr=yr, zlog=zlog, dmap=dmap, median=median, levels=levels, $
    weight=weight, wlog=wlog, legend=legend, lbottom=lbottom, ltop=ltop, lwidth=lwidth, ctitle=ctitle, $
    charsize=charsize, noerase=noerase, lextra=lextra, reduce=reduce, xthick=xthick, ythick=ythick, $
    _extra=cextra

    dmap = bin_map(x, y, z, numbins=numbins, xr=xr, yr=yr, median=median, reduce=reduce, weight=weight)
    if keyword_set(zlog) then dmap = alog10(dmap)
    if keyword_set(legend) then begin
        bleg = bake_legend(top=ltop, bottom=lbottom, width=lwidth, title=provided(ctitle))
        mppos = bleg.plot_pos
        bppos = bleg.leg_pos
        tppos = bleg.tit_pos

        plot2d, dmap, levels=levels, noerase=noerase, /noplot, _extra=cextra

        if provided(charsize) then lcs = charsize
        if provided(lextra) then begin
            wcs = where(tag_names(lextra) eq 'CHARSIZE', cnt)
            if cnt ne 0 then lcs = lextra.(wcs[0])
        endif

        colegend, levels, /range, position=bppos, xtit=ctitle, bottom=lbottom, top=ltop, $
            charsize=lcs, titpos=tppos, noerase=noerase, xthick=xthick, ythick=ythick, $
            _extra=lextra
    endif

    plot2d, dmap, imgxrange=xr, imgyrange=yr, levels=levels, position=mppos, $
        charsize=charsize, noerase=(keyword_set(legend) or keyword_set(noerase)), $
        xthick=xthick, ythick=ythick, _extra=cextra
end
