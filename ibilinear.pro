function ibilinear, data, x, y, xp, yp, _extra=extra
    xi = interpol(dindgen(n_elements(x)), double(x), double(xp)) 
    yi = interpol(dindgen(n_elements(y)), double(y), double(yp))
    return, bilinear(data, xi, yi, _extra=extra)
end
