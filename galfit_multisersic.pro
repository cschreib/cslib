function galfit_multisersic_read_param, hdr, name
    str = (strsplit(sxpar(hdr, name), /extract))[0]
    if strstart(str, '[') then begin
        str = strmid(str, 1, strlen(str)-2)
    endif
    if strstart(str, '*') then begin
        str = strmid(str, 1, strlen(str)-2)
    endif
    return, float(str)
end

; Example usage:
; --------------
;
; nsersic = 2
; params = replicate({x:39.35, free_x:1, y:39.7, free_y:1, index:0.5, free_index:0, ratio:1.0, $
;     free_ratio:0, angle:0, free_angle:0, mag:18.82, free_mag:1, size:0.0, free_size:0}, nsersic)

; p = params[nsersic-1]
; p.x = 27.526
; p.y = 35.281
; p.mag = 22.0
; params[nsersic-1] = p

; galfit_multisersic, 'subaru-ib738.fits', params, $
;     badpix='badpix.fits', psf='model_psf_x10.galfit.fits', sampling_psf=10, $
;     aspix=0.267, magzp=26.0, /showfit, chi2=chi2, params=best_fit, /cleanup

pro galfit_multisersic, filename, inparams, output=output, error=error, psf=psf, badpix=badpix, aspix=aspix, $
    magzp=magzp, galfit=galfit, success=success, model=model, hdr=hdr, cleanup=cleanup, chi2=chi2, $
    showfit=showfit, tmp_dir=tmp_dir, samepos=samepos, sameangle=sameangle, nobg=nobg, $
    sampling_psf=sampling_psf, params=params

    if n_elements(filename) eq 0 then begin
        message, 'missing file to fit!'
    endif

    extpos = strpos(filename, '.fits')
    if extpos lt 0 then begin
        message, 'input file must be a FITS image'
    endif

    filebase = strmid(filename, 0, extpos)

    if ~provided(aspix) then aspix = 1.0
    if ~provided(sampling_psf) then sampling_psf = 1.0
    if ~provided(magzp) then magzp = 23.9
    if ~provided(output) then output = filebase
    if ~provided(galfit) then galfit = 'galfit3'
    if ~provided(tmp_dir) then tmp_dir = '/tmp/'

    imgsize = size(mrdfits(filename, /silent), /dim)

    fsizex = strn(imgsize[0])
    hsizex = strn(imgsize[0]/2 + 1)
    fsizey = strn(imgsize[1])
    hsizey = strn(imgsize[1]/2 + 1)

    if provided(psf) then begin
        if ~file_test(psf) then begin
            message, 'could not find PSF file "'+psf+'"'
        endif
    endif

    tmodel = strn(keyword_set(model))
    out_file = output+'.galfit.fits'

    if tmodel eq '1' then begin
        tmp_out_file = out_file
    endif else begin
        tmp_out_file = tmp_dir+'output.galfit.fits'
    endelse

    nsersic = n_elements(inparams)
    has_constraint = (keyword_set(samepos) or keyword_set(sameangle)) and nsersic gt 1

    constraints = 'none'
    if has_constraint then begin
        constraints = output+'.galfit.const'
        openw, 1, constraints
        if keyword_set(samepos) then for i=1, nsersic-1 do begin
            printf, 1, strn(i+1)+'-'+strn(i)+'  x  0 0'
            printf, 1, strn(i+1)+'-'+strn(i)+'  y  0 0'
        endfor
        if keyword_set(sameangle) then for i=1, nsersic-1 do begin
            printf, 1, strn(i+1)+'-'+strn(i)+'  pa  0 0'
        endfor
        close, 1
    endif

    spawn, 'rm -f '+tmp_out_file

    openw, 1, output+'.galfit.conf'
    printf, 1, 'A) '+filename                            ; Input image
    printf, 1, 'B) '+tmp_out_file                        ; Output image
    if provided(error) then begin
    printf, 1, 'C) '+error                               ; Input error
    endif else begin
    printf, 1, 'C) none'                                 ; Input error
    endelse
    if provided(psf) then begin
    printf, 1, 'D) '+psf                                 ; PSF image
    endif else begin
    printf, 1, 'D) none'                                 ; PSF image
    endelse
    printf, 1, 'E) '+strn(sampling_psf)                  ; PSF sampling
    if provided(badpix) then begin
    printf, 1, 'F) '+badpix                              ; Bad pixel mask image
    endif else begin
    printf, 1, 'F) none'                                 ; PSF image
    endelse
    printf, 1, 'G) '+constraints                         ; Parameter contraints file
    printf, 1, 'H) 1 '+fsizex+' 1 '+fsizey               ; Fit region
    printf, 1, 'I) '+fsizex+' '+fsizey                   ; Convolution region
    printf, 1, 'J) '+strn(magzp)                         ; Magnitude zero point
    printf, 1, 'K) '+strn(aspix)+' '+strn(aspix)         ; Arcsec/pixel
    printf, 1, 'O) regular'                              ; Interaction window
    printf, 1, 'P) '+tmodel                              ; Options
    printf, 1, 'S) 0'                                    ; Interactive

    for i=0, nsersic-1 do begin
        p = inparams[i]

        if p.size eq 0 then begin
            printf, 1, '0) psf'                                  ; Shape
            printf, 1, '1) '+strn(p.x)+' '+strn(p.y)+' '+strn(p.free_x)+' '+strn(p.free_y) ; X and Y positions
            printf, 1, '3) '+strn(p.mag)+' '+strn(p.free_mag)          ; Magnitude
            printf, 1, 'Z) 0'                                    ; Options
        endif else begin
            printf, 1, '0) sersic'                               ; Shape
            printf, 1, '1) '+strn(p.x)+' '+strn(p.y)+' '+strn(p.free_x)+' '+strn(p.free_y) ; X and Y positions
            printf, 1, '3) '+strn(p.mag)+' '+strn(p.free_mag)          ; Magnitude
            printf, 1, '4) '+strn(p.size)+' '+strn(p.free_size)        ; Half size
            printf, 1, '5) '+strn(p.index)+' '+strn(p.free_index)     ; Sersic index
            printf, 1, '9) '+strn(p.ratio)+' '+strn(p.free_ratio)      ; Axis ratio
            printf, 1, '10) '+strn(p.angle)+' '+strn(p.free_angle)     ; Angle
            printf, 1, 'Z) 0'                                    ; Option
        endelse
    endfor

    printf, 1, '0) sky'                                  ; Sky
    printf, 1, '1) 0.0 '+strn(~keyword_set(nobg))        ; DC offset of ADU
    printf, 1, '2) 0.0 0'                                ; Gradient in X
    printf, 1, '3) 0.0 0'                                ; Gradient in Y
    printf, 1, 'Z) 0'                                    ; Option

    close, 1

    spawn, galfit+' '+output+'.galfit.conf > '+output+'.galfit.out'

    if ~file_test(tmp_out_file) then begin
        print, 'warning: galfit did not converge or crashed!'
        success = 0
    endif else begin
        success = 1

        if keyword_set(showfit) then begin
            plotgalfit2, tmp_out_file, badpix=badpix
        endif

        if ~keyword_set(model) then begin
            img  = mrdfits(tmp_out_file, 1, /silent)
            modl = mrdfits(tmp_out_file, 2, hdr, /silent)
            resi = mrdfits(tmp_out_file, 3, /silent)

            cube = [[[img]], [[modl]], [[resi]]]
            writefits, out_file, cube, hdr
        endif else begin
            modl = mrdfits(tmp_out_file, 0, hdr, /silent)
        endelse
    endelse

    params = inparams
    if success then begin
        chi2 = galfit_multisersic_read_param(hdr, 'CHI2NU')

        for i=0, nsersic-1 do begin
            si = strn(i+1)
            p = params[i]

            p.x     = galfit_multisersic_read_param(hdr, si+'_XC')
            p.y     = galfit_multisersic_read_param(hdr, si+'_YC')
            p.size  = galfit_multisersic_read_param(hdr, si+'_RE')
            p.ratio = galfit_multisersic_read_param(hdr, si+'_AR')
            p.angle = galfit_multisersic_read_param(hdr, si+'_PA')
            p.index = galfit_multisersic_read_param(hdr, si+'_N')
            p.mag   = galfit_multisersic_read_param(hdr, si+'_MAG')

            params[i] = p
        endfor
    endif

    if keyword_set(cleanup) then begin
        spawn, 'rm -f galfit.01'
        spawn, 'rm -f fit.log'
        if ~keyword_set(model) then spawn, 'rm -f '+tmp_out_file
        spawn, 'rm -f '+output+'.galfit.out'
        spawn, 'rm -f '+output+'.galfit.conf'
        spawn, 'rm -f '+output+'.galfit.const'
    endif
end
