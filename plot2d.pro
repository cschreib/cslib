; Plot a 2D array (an image for example).
;
; Arguments:
;  - data: the 2D array to plot
;
; Keywords:
;  - coltable: the color table to use when plotting the image. The color of a given data value
;              will be computed by interpolation if there are less colors in this table than the
;              number of levels. You can provide a single color that will be used for all values.
;              Defaults to grey scale.
;  - nlevel: the number of levels to use to display the distribution. The more, the prettier.
;  - levels: [input/output] the density levels and colors that were used to display the plot
;  - uselevels: set this flag if you want the procedure to use the provided 'levels' for plotting
;  - range: min and max values to use as first and last colors. Can be used to enhance the constrast
;           of the image.
;  - nan: color to use to plot infinite or NaN values (default: background color)
;  - + all the keywords available to 'plotimage'
;
pro plot2d, data, coltable=coltable, levels=levels, nlevel=nlevel, uselevels=uselevels, range=range, $
    nan=nan, weight=weight, wrange=wrange, wrrel=wrrel, noplot=noplot, _extra=cextra
    if ~keyword_set(uselevels) or ~provided(levels) then begin
        if ~provided(coltable) then coltable = 'viridis'
        if size(coltable, /tname) eq 'STRING' then coltable = color_rainbow(table=coltable)
        if ~provided(range) then begin
            idg = where(finite(data), cnt)
            if cnt eq 0 then message, 'error: no data to plot!'
            range = [min(data[idg]), max(data[idg])]
        endif
        if ~provided(nlevel) then nlevel = 253
        nlevel = min([nlevel, 253])

        levels = {range:range, color:color_rainbow(findgen(nlevel)/(nlevel-1), rbow=coltable), rbow:coltable}
    endif

    if keyword_set(noplot) then return

    tdatar = bytarr(n_elements(data[*,0]), n_elements(data[0,*]))
    tdatag = tdatar
    tdatab = tdatar

    if ~provided(nan) then nan = !p.background
    tdatar[*,*] = color_r(nan)
    tdatag[*,*] = color_g(nan)
    tdatab[*,*] = color_b(nan)

    idg = where(finite(data), cnt)
    if cnt ne 0 then begin
        tmp = (n_elements(levels.color)-1)*clamp((data[idg] - levels.range[0])/float(levels.range[1] - levels.range[0]))
        col = levels.color[tmp]

        if provided(weight) then begin
            if ~provided(wrange) then wrange = [min(weight[idg]), max(weight[idg])]
            if keyword_set(wrrel) then wrange *= max(weight[idg])
            col = color_interpol(!p.background, col, clamp((weight[idg] - wrange[0])/float(wrange[1] - wrange[0])))
        endif

        tdatar[idg] = color_r(col)
        tdatag[idg] = color_g(col)
        tdatab[idg] = color_b(col)
    endif

    plotimage, [[[tdatar]], [[tdatag]], [[tdatab]]], truedim=3, _extra=cextra
end

