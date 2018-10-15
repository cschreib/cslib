; Like 'plot' but the color of the data points is determined by a third array
;
; Arguments:
;  - xdata: x axis data
;  - ydata: y axis data
;  - coldata: color level data
;
; Keywords:
;  - coltable: the color table to use for coloring the points (see 'color' to build an RGB color easily)
;  - numbins: specify the number of color bins to use (default : see 'ocolplot')
;  - linearbins: set this flag if you want bins with linear spacing (else constant population is used)
;  - bins: in/out variable containing the color bins
;  - usebins: set this flag if you want the procedure to use the provided 'bins' for plotting.
;             Then, if 'bins' is a simple array, its elements will be considered as the boundaries
;             of the bins to create, i.e. [0,1,2] will create bins [0,1] and [1,2]. If 'bins' is
;             a structure with field 'low' and 'up', defining the lower and upper bound of the bins,
;             then these bins will be used for display. If 'bins' is the output of a previous call
;             to 'colplot' or 'ocolplot', then it will also contain the colors of each bin.
;  - + all the keywords available to 'plot' ('psym' defaults to 3)
;
pro colplot, xdata, ydata, coldata, psym=psym, symsize=symsize, nodata=nodata, numbins=numbins, $
    coltable=coltable, linearbins=linearbins, bins=bins, usebins=usebins, position=position, $
    legend=legend, lbottom=lbottom, ltop=ltop, lwidth=lwidth, llog=llog, ctitle=ctitle, range=range, $
    charsize=charsize, noerase=noerase, lextra=lextra, linestyle=linestyle, thick=thick, $
    reverse=reverse, random=random, openrange=openrange, inset_legend=inset_legend, _extra=cpextra

    if keyword_set(legend) then begin
        bleg = bake_legend(top=ltop, bottom=lbottom, width=lwidth, title=provided(ctitle), $
            inset_legend=inset_legend)

        mppos = bleg.plot_pos
        bppos = bleg.leg_pos
        tppos = bleg.tit_pos

        ocolplot, xdata, ydata, coldata, psym=psym, symsize=symsize, numbins=numbins, $
            coltable=coltable, linearbins=linearbins, bins=bins, usebins=usebins, $
            linestyle=linestyle, range=range, /nodata

        if provided(charsize) then lcs = charsize
        if provided(lextra) then begin
            wcs = where(tag_names(lextra) eq 'CHARSIZE', cnt)
            if cnt ne 0 then lcs = lextra.(wcs[0])
        endif

        colegend, bins, position=bppos, xtit=ctitle, bottom=lbottom, top=ltop, llog=llog, $
            titpos=tppos, charsize=lcs, _extra=lextra, noerase=noerase
    endif else if provided(position) then mppos = position

    plot, xdata, ydata, /nodata, position=mppos, charsize=charsize, _extra=cpextra, $
        linestyle=linestyle, noerase=(keyword_set(legend) or keyword_set(noerase))

    ocolplot, xdata, ydata, coldata, psym=psym, symsize=symsize, numbins=numbins, coltable=coltable, $
        linestyle=linestyle, linearbins=linearbins, bins=bins, usebins=usebins, thick=thick, $
        range=range, nodata=nodata, reverse=reverse, random=random, openrange=openrange
end
