; Create a 2D histogram of the provided data set.
; See 'densplot' if you want to display such histogram ('densplot' uses this function).
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
;  - xdata: [output] the 'x' axis points corresponding to the returned array
;  - ydata: [output] the 'y' axis points corresponding to the returned array
;  - continuous: set this keyword if you do not want the 'squared' histogram-like aspect, but a
;                continuous density distribution
;  - smooth: if non zero, will smooth out every bin of the map by a circular kernel or radius
;            'smooth' (in number of bins). Warning: can be slow.
;  - normalized: set this keyword to generate a normalized distribution, where all values are
;                relative to the total number of elements in the considered sample
;
function density_map, x, y, numbins=numbins, xr=xr, yr=yr, xdata=xdata, ydata=ydata, $
    continuous=continuous, smooth=smooth, normalized=normalized, weight=weight

    if ~provided(numbins) then numbins = [20, 20] else $
        if n_elements(numbins) eq 1 then numbins = [numbins, numbins]

    if ~provided(xr) then xr = [min(x), max(x)]
    if ~provided(yr) then yr = [min(y), max(y)]

    dosmooth = 0
    if provided(smooth) then begin
        if smooth ne 0 then dosmooth = 1
    endif

    xstep = (xr[1]-xr[0])/float(numbins[0]-1)
    ystep = (yr[1]-yr[0])/float(numbins[1]-1)

    xdata = (findgen(numbins[0]) + 0.5)*xstep + xr[0]
    ydata = (findgen(numbins[1]) + 0.5)*ystep + yr[0]
    if dosmooth or provided(weight) then begin
        dmap = fltarr(numbins[0], numbins[1])
    endif else begin
        dmap = lonarr(numbins[0], numbins[1])
    endelse

    factor = 0.0
    void = histogram(x, binsize=xstep, nbins=numbins[0], min=xr[0], reverse=rix)
    for xi=0L, numbins[0]-1 do begin
        if rix[xi] eq rix[xi+1] then continue
        tmp1 = rix[rix[xi]:rix[xi+1]-1]
        if provided(weight) then begin
            void = histogram(y[tmp1], binsize=ystep, nbins=numbins[1], min=yr[0], reverse=riy)
            for yi=0L, numbins[1]-1 do begin
                if riy[yi] eq riy[yi+1] then continue
                tmp2 = riy[riy[yi]:riy[yi+1]-1]
                dmap[xi,yi] = total(weight[tmp1[tmp2]])
                factor += n_elements(tmp2)
            endfor
        endif else begin
            dmap[xi,*] = histogram(y[tmp1], binsize=ystep, nbins=numbins[1], min=yr[0])
        endelse
    endfor

    if ~provided(weight) then factor = total(dmap)

    if dosmooth then begin
        odmap = dmap
        for xi=0L, numbins[0]-1 do for yi=0L, numbins[1]-1 do begin
            m = circular_mask(numbins, [xi,yi], smooth)
            idz = where(m ne 0.0)
            dmap[xi,yi] = total(odmap[idz]*m[idz])/total(m[idz])
        endfor
    endif

    if keyword_set(normalized) then dmap /= factor

    if keyword_set(continuous) then return, dmap

    xdata = ceil(findgen(2*numbins[0])/2.0)*xstep + xr[0]
    ydata = ceil(findgen(2*numbins[1])/2.0)*ystep + yr[0]

    ndmap = fltarr(numbins[0]*2, numbins[1]*2)
    for xi=0L, numbins[0]-1 do for yi=0L, numbins[1]-1 do begin
        ndmap[2*xi+0,2*yi+0] = dmap[xi, yi]
        ndmap[2*xi+1,2*yi+0] = dmap[xi, yi]
        ndmap[2*xi+0,2*yi+1] = dmap[xi, yi]
        ndmap[2*xi+1,2*yi+1] = dmap[xi, yi]
    endfor

    return, ndmap
end
