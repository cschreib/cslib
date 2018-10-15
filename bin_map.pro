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
function bin_map, x, y, z, numbins=numbins, xr=xr, yr=yr, xdata=xdata, ydata=ydata, $
    median=median, reduce=reduce, weight=weight

    if n_elements(weight) ne 0 then begin
        if n_elements(reduce) eq 0 then begin
            return, density_map(x, y, xr=xr, yr=yr, xdata=ydata, ydata=ydata, numbins=numbins, $
                /continuous, data={data:z, weight:weight}, $
                operation='total(data.data[ids]*data.weight[ids])/total(data.weight[ids])')
        endif else if keyword_set(median) then begin
            return, density_map(x, y, xr=xr, yr=yr, xdata=ydata, ydata=ydata, numbins=numbins, $
                /continuous, data={data:z, weight:weight}, $
                operation='weighted_median(data.data[ids], data.weight[ids])')
        endif else begin
            return, density_map(x, y, xr=xr, yr=yr, xdata=ydata, ydata=ydata, numbins=numbins, $
                /continuous, data={data:z, weight:weight}, $
                operation=reduce)
        endelse
    endif else begin
        if n_elements(reduce) eq 0 then begin
            return, density_map(x, y, xr=xr, yr=yr, xdata=ydata, ydata=ydata, numbins=numbins, $
                /continuous, data=z, operation='mean(data[ids])')
        endif else if keyword_set(median) then begin
            return, density_map(x, y, xr=xr, yr=yr, xdata=ydata, ydata=ydata, numbins=numbins, $
                /continuous, data=z, operation='median(data[ids])')
        endif else begin
            return, density_map(x, y, xr=xr, yr=yr, xdata=ydata, ydata=ydata, numbins=numbins, $
                /continuous, data=z, operation=reduce)
        endelse
    endelse
end
