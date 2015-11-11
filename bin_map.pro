; Create a 2D binned mean of the provided 3D data set.
; See 'binplot' if you want to display such histogram ('binplot' uses this function).
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
;  - xdata: [output] the 'x' axis points corresponding to the returned array
;  - ydata: [output] the 'y' axis points corresponding to the returned array
;
function bin_map, x, y, z, numbins=numbins, xr=xr, yr=yr, xdata=xdata, ydata=ydata, median=median, reduce=reduce

    if ~provided(numbins) then numbins = [20, 20] else $
        if n_elements(numbins) eq 1 then numbins = [numbins, numbins]

    if ~provided(xr) then xr = [min(x), max(x)]
    if ~provided(yr) then yr = [min(y), max(y)]

    xstep = (xr[1]-xr[0])/float(numbins[0])
    ystep = (yr[1]-yr[0])/float(numbins[1])

    xdata = ceil(findgen(2*numbins[0])/2.0)*xstep + xr[0]
    ydata = ceil(findgen(2*numbins[1])/2.0)*ystep + yr[0]
    dmap  = fltarr(numbins[0]*2, numbins[1]*2)*!values.f_nan

    for xi=0L, numbins[0]-1 do begin
        tmp1 = where(xr[0]+xi*xstep le x and x lt xr[0]+(xi+1)*xstep, cnt)
        if cnt eq 0 then continue
        for yi=0L, numbins[1]-1 do begin
            tmp2 = where(yr[0]+yi*ystep le y[tmp1] and y[tmp1] lt yr[0]+(yi+1)*ystep, cnt)
            if cnt ne 0 then begin
                if keyword_set(median) then begin
                    ; Do median
                    val = median(z[tmp1[tmp2]])
                endif else if provided(reduce) then begin
                    ; Do custom stuff
                    v = z[tmp1[tmp2]]
                    void = execute('val = '+reduce)
                endif else begin
                    ; Just do mean
                    val = mean(z[tmp1[tmp2]])
                endelse
            endif else begin
                val = !values.f_nan
            endelse

            dmap[2*xi+0, 2*yi+0] = val
            dmap[2*xi+1, 2*yi+0] = val
            dmap[2*xi+0, 2*yi+1] = val
            dmap[2*xi+1, 2*yi+1] = val
        endfor
    endfor

    return, dmap
end
