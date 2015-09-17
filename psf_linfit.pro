; Fit a PSF to an image, assuming there is a source at the center.
;
; Arguments:
;  - img: the image to fit
;  - err: the error on each pixel (can be a single value)
;  - psf: the PSF to fit (can have dimensions different from the image)
;
; Return value:
;    [background, flux]
;
; Keywords:
;  - frac: pixels of the PSF below this fraction of the peak amplitude are not used
;  - error: [output] errors on the fit parameters
;  - residual: [output] contains the residual map after subtracting the fitted PSF
;
function psf_linfit, img, err, psf, frac=frac, error=error, residual=residual
    ; Default values
    if n_elements(frac) eq 0 then frac = 0.1

    ; If error is only one value, assume that all pixels have this same error
    if n_elements(err) eq 1 then begin
        err = replicate(err[0], n_elements(img[*,0]), n_elements(img[0,*]))
    endif

    ; Reshape the PSF
    ; ---------------
    hx = n_elements(psf[*,0])/2
    hy = n_elements(psf[0,*])/2

    ; First locate the peak
    void = max(psf, mid)
    mid = array_indices(psf, mid)

    ; Then locate the end of non-zero values
    n = min([hx, hy])
    for i=1, n-1 do begin
        if psf[mid[0]+i,mid[1]] eq 0 and psf[mid[0]-i,mid[1]] eq 0 and $
           psf[mid[0],mid[1]+i] eq 0 and psf[mid[0],mid[1]+i] eq 0 then begin
            hsize = i
            break
        endif
    endfor

    if n_elements(hsize) eq 0 then hsize = n

    ; This is the optimal, centered PSF
    tpsf = psf[mid[0]-hsize:mid[0]+hsize, mid[1]-hsize:mid[1]+hsize]

    ; Prepare the image
    ; -----------------

    ; Assuming the source is at the center
    hx = n_elements(img[*,0])/2
    hy = n_elements(img[0,*])/2
    n = min([hx,hy])

    if n lt hsize then begin
        timg = tpsf*!values.f_nan
        terr = tpsf*!values.f_nan
        timg[hsize-hx:hsize+hx, hsize-hy, hsize+hy] = img
        terr[hsize-hx:hsize+hx, hsize-hy, hsize+hy] = err
    endif else begin
        timg = img[hx-hsize:hx+hsize, hy-hsize:hy+hsize]
        terr = err[hx-hsize:hx+hsize, hy-hsize:hy+hsize]
    endelse

    ; Select pixels where the PSF amplitude is high enough,
    ; to prevent a good fraction (but not all) of clustering.
    ; Also reject invalid pixels from the image
    id = where(tpsf gt 0.1*max(tpsf) and finite(timg) and finite(terr), cnt)
    if cnt eq 0 then begin
        message, 'no pixel to fit...'
    endif

    ; Do the fit
    ; ----------
    p = linfit(tpsf[id], timg[id], measure=terr[id], sigma=error)

    ; Build the residual map, if asked
    if arg_present(residual) then begin
        residual = img
        if n lt hsize then begin
            residual -= p[1]*tpsf[hsize-hx:hsize+hx, hsize-hy:hsize+hy]
        endif else begin
            tmp = residual[hx-hsize:hx+hsize, hy-hsize:hy+hsize]
            tmp -= p[1]*tpsf
            residual[hx-hsize:hx+hsize, hy-hsize:hy+hsize] = tmp
        endelse
    endif

    return, p
end
