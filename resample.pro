function resample, img, factor
    nx = n_elements(img[*,0])
    ny = n_elements(img[0,*])
    tx = areplicate(factor*indgen(nx/factor), ny/factor, /transpose)
    ty = areplicate(factor*indgen(ny/factor), nx/factor)
    return, interpol2d(img, indgen(nx), indgen(ny), tx, ty)
end
