; Helper procedure to quickly compare two data sets that would be equal in an ideal world.
; This will plot 'y - x' versus 'x', overplotting a 1:1 correlation line, a sliding median and two
; sliding percentiles. The points can also be colored using an additional array as in 'colplot'.
;
; Arguments:
;  - xdata: first data set (will be used as 'x' axis)
;  - ydata: second data set
;  - coldata: [optional] aditional data to use to color the points (see 'colplot')
;
; Keywords:
;  - psym, symsize, color, xtit, ytit: same as for 'plot'
;  - useytit: set this keyword to prevent the 'ytit' to be automatically modified
;  - log: set this keyword to compare the logarithm of the provided data sets
;  - medr: see 'slidemed' -> 'xr'
;  - perc: the 'slidemed'
;  - medsample: see 'slidemed' -> 'sample_size'
;  - medcolor: the color to use to display the sliding median (default: red)
;  - perccolor: the color to use to display the sliding percentiles (default: green)
;  - midcolor: the color to use to display the 1:1 ideal correlation (default: yellow)
;  - linestyle: the line style to use to display the 1:1 relation, the sliding median, the lower
;               percentile and the upper percentile respectively (array of 4 line styles)
;  - rsm: [output] the sliding median and percentiles as output from 'slidemed'
;  - + all keywords available to 'plot' (or 'colplot' if 'coldata' is set)
;
pro cmpplot, xdata, ydata, coldata, psym=psym, symsize=symsize, color=color, xtit=xtit, ytit=ytit, useytit=useytit, log=log, bins=bins, thick=thick, $
    medr=medr, perc=perc, medsample=medsample, medcolor=medcolor, perccolor=perccolor, midcolor=midcolor, linestyle=linestyle, rsm=rsm, info=info, rel=rel, _extra=pextra

    Compile_Opt idl2

    if ~provided(linestyle) then linestyle=[2,0,2,2]
    if ~provided(psym) then psym=3
    if ~provided(thick) then thick=4

    if keyword_set(log) then begin
        idok = where(finite(xdata) and xdata ne 0.0 and finite(ydata) and ydata ne 0.0)
        txdata = alog10(xdata[idok])
        tydata = alog10(ydata[idok])
    endif else if keyword_set(rel) then begin
        idok = where(finite(xdata) and finite(ydata))
        txdata = xdata[idok]
        tydata = ydata[idok]/xdata[idok] - 1 + xdata[idok]
    endif else begin
        idok = where(finite(xdata) and finite(ydata))
        txdata = xdata[idok]
        tydata = ydata[idok]
    endelse

    if keyword_set(info) then begin
        data_info, tydata - txdata
    endif

    if provided(xtit) and provided(ytit) and ~keyword_set(useytit) then begin
        ytit = ytit+' - '+xtit
    endif

    if ~provided(medcolor)  then medcolor  = color(255,0,0)
    if ~provided(perccolor) then perccolor = color(0,255,0)
    if ~provided(midcolor)  then midcolor  = color(255,255,0)

    if provided(coldata) then begin
        colplot, txdata, tydata - txdata, coldata[idok], psym=psym, symsize=symsize, xtit=xtit, ytit=ytit, bins=bins, _extra=pextra
    endif else begin
        if provided(color) then begin
            plot, txdata, tydata - txdata, xtit=xtit, ytit=ytit, /nodata, _extra=pextra
            oplot, txdata, tydata - txdata, psym=psym, symsize=symsize, color=color
        endif else begin
            plot, txdata, tydata - txdata, psym=psym, symsize=symsize, xtit=xtit, ytit=ytit, _extra=pextra
        endelse
    endelse

    oplot, !x.crange, [0.0, 0.0], color=midcolor, thick=thick, linestyle=linestyle[0]

    rsm = slidemed(txdata, tydata - txdata, xr=medr, perc=perc, num_pts=medsample, min_sample=1)
    oplot, rsm.x, rsm.med, linestyle=linestyle[1], col=medcolor,  thick=thick
    oplot, rsm.x, rsm.low, linestyle=linestyle[2], col=perccolor, thick=thick
    oplot, rsm.x, rsm.up,  linestyle=linestyle[3], col=perccolor, thick=thick
end
