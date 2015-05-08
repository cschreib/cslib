; Like 'oplot' but the color of the data points is determined by a third array
;
; Arguments:
;  - xdata: x axis data
;  - ydata: y axis data
;  - coldata: color level data
;
; Keywords:
;  - coltable: the color table to use for coloring the points (see 'color' to build an RGB color
;              easily)
;  - numbins: specify the number of color bins to use (default : see 'ocolplot')
;  - linearbins: set this flag if you want bins with linear spacing (else constant population is
;                used)
;  - bins: in/out variable containing the color bins
;  - usebins: set this flag if you want the procedure to use the provided 'bins' for plotting.
;             Then, if 'bins' is a simple array, its elements will be considered as the boundaries
;             of the bins to create, i.e. [0,1,2] will create bins [0,1] and [1,2]. If 'bins' is
;             a structure with field 'low' and 'up', defining the lower and upper bound of the bins,
;             then these bins will be used for display. If 'bins' is the output of a previous call
;             to 'colplot' or 'ocolplot', then it will also contain the colors of each bin.
;  - + all the keywords available to 'oplot' ('psym' defaults to 3)
;
pro ocolplot, xdata, ydata, coldata, psym=psym, symsize=symsize, nodata=nodata, numbins=tnumbins, $
    coltable=coltable, linearbins=linearbins, bins=bins, usebins=usebins, linestyle=linestyle, $
    thick=thick, range=range, reverse=reverse, random=random, openrange=openrange

    if ~provided(psym) then psym = 3
    if ~provided(coltable) then coltable = [color(255,0,0), color(0,0,255)]
    if size(coltable, /tname) eq 'STRING' then coltable = color_rainbow(table=coltable)
    if provided(tnumbins) then numbins = tnumbins

    if provided(bins) and keyword_set(usebins) then begin
        if size(bins, /tname) eq 'STRUCT' then begin
            numbins = n_elements(bins.low)
        endif else begin
            numbins = n_elements(bins)-1
            bins = {low:bins[lindgen(numbins)], up:bins[lindgen(numbins)+1]}
        endelse

        if total(tag_names(bins) eq 'COLOR') eq 0 then begin
            bins = {low:bins.low, up:bins.up, $
                color:color_rainbow(findgen(numbins)/(numbins-1.0), rbow=coltable)}
        endif
    endif else begin
        if ~provided(numbins) then numbins = 10
        makebins, coldata, numbins=numbins, linearbins=linearbins, bins=bins, range=range
        bins = {low:bins.low, up:bins.up, $
            color:color_rainbow(findgen(numbins)/(numbins-1.0), rbow=coltable)}
    endelse

    if keyword_set(nodata) then return

    if keyword_set(random) then begin
        nsrc = n_elements(coldata)
        cols = replicate(bins.color[0], nsrc)
        sel = bytarr(nsrc)
        for b=0L, numbins-1L do begin
            if keyword_set(openrange) and b eq 0L then begin
                low = finite(coldata)
            endif else begin
                low = coldata ge bins.low[b]
            endelse

            if keyword_set(openrange) and b eq numbins-1L then begin
                up = finite(coldata)
            endif else begin
                up = coldata lt bins.up[b]
            endelse

            idin = where(low and up, cnt)
            if cnt eq 0 then continue
            cols[idin] = bins.color[b]
            sel[idin] = 1
        endfor

        isel = where(sel, cnt)
        if cnt ne 0 then begin
            bids = shuffle(isel, seed=42)
            plots, xdata[bids], ydata[bids], psym=psym, symsize=symsize, $
                col=cols[bids], noclip=0
        endif
    endif else begin
        for tb=0L, numbins-1L do begin
            if keyword_set(reverse) then b = numbins-1L-tb else b = tb

            if keyword_set(openrange) and b eq 0L then begin
                low = finite(coldata)
            endif else begin
                low = coldata ge bins.low[b]
            endelse

            if keyword_set(openrange) and b eq numbins-1L then begin
                up = finite(coldata)
            endif else begin
                up = coldata lt bins.up[b]
            endelse

            idin = where(low and up, cnt)
            if cnt eq 0 then continue
            oplot, xdata[idin], ydata[idin], psym=psym, symsize=symsize, $
                col=bins.color[b], linestyle=linestyle, thick=thick
        endfor
    endelse
end

