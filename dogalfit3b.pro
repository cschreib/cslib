function dogalfit2_read_param, hdr, name
    str = (strsplit(sxpar(hdr, name), /extract))[0]
    if strstart(str, '[') then begin
        str = strmid(str, 1, strlen(str)-2)
    endif
    if strstart(str, '*') then begin
        str = strmid(str, 1, strlen(str)-2)
    endif
    return, float(str)
end

pro dogalfit3b, filename, imgsize, output=output, error=error, psf=psf, badpix=badpix, aspix=aspix, $
    magzp=magzp, galfit=galfit, success=success, freepos=freepos, freemag=freemag, $
    freesersic=freesersic, freeratio=freeratio, freeangle=freeangle, freesize=freesize, $
    setpos=setpos, setmag=setmag, setratio=setratio, setangle=setangle, setsize=setsize, $
    setindex=setindex, multisersic=multisersic, model=model, hdr=hdr, cleanup=cleanup, $
    showfit=showfit, tmp_dir=tmp_dir, samepos=samepos, max_dpos=max_dpos, sameangle=sameangle, $
    nobg=nobg, add_psf=add_psf, setbt=setbt, params=params, useparams=useparams

    if n_elements(filename) eq 0 then begin
        message, 'missing file to fit!'
    endif

    extpos = strpos(filename, '.fits')
    if extpos lt 0 then begin
        message, 'input file must be a FITS image'
    endif

    filebase = strmid(filename, 0, extpos)

    if ~provided(aspix) then aspix = 1.0
    if ~provided(multisersic) then multisersic = 1
    if ~provided(magzp) then magzp = 23.9
    if ~provided(output) then output = filebase
    if ~provided(galfit) then galfit = 'galfit3'
    if ~provided(tmp_dir) then tmp_dir = '/tmp/'
    if n_elements(imgsize) eq 0 then begin
        tmp = mrdfits(filename, /silent)
        timgsize = size(tmp, /dim)
        tmp = 0
    endif else timgsize = imgsize
    if n_elements(timgsize) lt 2 then timgsize = [timgsize, timgsize]
    if n_elements(timgsize) gt 2 then timgsize = timgsize[1:2]

    if provided(freepos) then begin
        tfreepos = freepos
        if n_elements(tfreepos) eq 1 then tfreepos = [tfreepos,tfreepos]
    endif else begin
        tfreepos = [0,0]
    endelse

    if provided(freemag) then begin
        tfreemag = freemag
        if n_elements(tfreemag) eq 1 then tfreemag = [tfreemag,tfreemag]
    endif else begin
        tfreemag = [0,0]
    endelse

    if provided(freesersic) then begin
        tfreesersic = freesersic
        if n_elements(tfreesersic) eq 1 then tfreesersic = [tfreesersic,tfreesersic]
    endif else begin
        tfreesersic = [0,0]
    endelse

    if provided(freeratio) then begin
        tfreeratio = freeratio
        if n_elements(tfreeratio) eq 1 then tfreeratio = [tfreeratio,tfreeratio]
    endif else begin
        tfreeratio = [0,0]
    endelse

    if provided(freeangle) then begin
        tfreeangle = freeangle
        if n_elements(tfreeangle) eq 1 then tfreeangle = [tfreeangle,tfreeangle]
    endif else begin
        tfreeangle = [0,0]
    endelse

    if provided(freesize) then begin
        tfreesize = freesize
        if n_elements(tfreesize) eq 1 then tfreesize = [tfreesize,tfreesize]
    endif else begin
        tfreesize = [0,0]
    endelse

    fsizex = strn(timgsize[0])
    hsizex = strn(timgsize[0]/2 + 1)
    fsizey = strn(timgsize[1])
    hsizey = strn(timgsize[1]/2 + 1)

    if keyword_set(useparams) and provided(params) then begin
        if multisersic gt 1 then begin
            setpos = fltarr(2,2)
            setpos[0,0] = timgsize[0]/2+1 - params.dx1
            setpos[1,0] = timgsize[1]/2+1 - params.dy1
            setpos[0,1] = timgsize[0]/2+1 - params.dx2
            setpos[1,1] = timgsize[1]/2+1 - params.dy2

            setsize = [params.radius1, params.radius2]
            setratio = [params.axis_ratio1, params.axis_ratio2]
            setangle = [params.angle1, params.angle2]
            setindex = [params.index1, params.index2]
            setmag = -2.5*alog10([params.flux1, params.flux2]) + magzp
        endif else begin
            setpos = fltarr(2)
            setpos[0] = timgsize[0]/2+1 - params.dx
            setpos[1] = timgsize[1]/2+1 - params.dy

            setsize = params.radius
            setratio = params.axis_ratio
            setangle = params.angle
            setindex = params.index
            setmag = -2.5*alog10(params.flux) + magzp
        endelse
    endif

    if provided(setpos) then begin
        if n_elements(setpos) eq 4 then begin
            posx1 = strn(setpos[0,0])
            posy1 = strn(setpos[1,0])
            posx2 = strn(setpos[0,1])
            posy2 = strn(setpos[1,1])
        endif else begin
            posx1 = strn(setpos[0])
            posy1 = strn(setpos[1])
            posx2 = strn(setpos[0])
            posy2 = strn(setpos[1])
        endelse
    endif else begin
        posx1 = hsizex
        posy1 = hsizey
        posx2 = hsizex
        posy2 = hsizey
    endelse

    if provided(setratio) then begin
        ratio1 = strn(setratio[0])
        if n_elements(setratio) eq 1 then begin
            ratio2 = strn(setratio[0])
        endif else begin
            ratio2 = strn(setratio[1])
        endelse
    endif else begin
        ratio1 = '1.0'
        ratio2 = '1.0'
    endelse

    if provided(setangle) then begin
        angle1 = strn(setangle[0])
        if n_elements(setangle) eq 1 then begin
            angle2 = strn(setangle[0])
        endif else begin
            angle2 = strn(setangle[1])
        endelse
    endif else begin
        angle1 = '0.0'
        angle2 = '0.0'
    endelse

    if provided(setsize) then begin
        size1 = strn(setsize[0])
        if n_elements(setsize) eq 1 then begin
            size2 = strn(setsize[0])
        endif else begin
            size2 = strn(setsize[1])
        endelse
    endif else begin
        size1 = strn(timgsize[0]/4)
        size2 = strn(timgsize[0]/4)
    endelse

    if provided(setindex) then begin
        index1 = strn(setindex[0])
        if n_elements(setindex) eq 1 then begin
            index2 = strn(setindex[0])
        endif else begin
            index2 = strn(setindex[1])
        endelse
    endif else begin
        index1 = '1.0'
        index2 = '4.0'
    endelse

    if provided(setmag) then begin
        mag1 = strn(setmag[0])
        if n_elements(setmag) eq 1 then begin
            mag2 = strn(setmag[0])
        endif else begin
            mag2 = strn(setmag[1])
        endelse
    endif else begin
        mag1 = '20.0'
        mag2 = '20.0'
    endelse

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

    has_constraint = keyword_set(samepos) or keyword_set(sameangle)

    constraints = 'none'
    if has_constraint then begin
        constraints = output+'.galfit.const'
        openw, 1, constraints
        if keyword_set(samepos) then begin
        if keyword_set(double_sersic) then begin
        printf, 1, '2-1  x  0 0'
        printf, 1, '2-1  y  0 0'
        if provided(max_dpos) then begin
        printf, 1, '1    x  '+strn(double(posx1)-max_dpos)+' '+strn(double(posx1)+max_dpos)
        printf, 1, '1    y  '+strn(double(posy1)-max_dpos)+' '+strn(double(posy1)+max_dpos)
        endif
        endif
        endif
        if keyword_set(sameangle) then begin
        if keyword_set(double_sersic) then begin
        printf, 1, '2-1  pa  0 0'
        endif
        endif
        if keyword_set(setbt) and keyword_set(double_sersic) then begin
        bf = -2.5*alog10(setbt/(1-setbt))
        if bf[1] lt bf[0] then bf = reverse(bf)
        printf, 1, '2-1  mag '+strn(bf[0])+' '+strn(bf[1])
        endif
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
    printf, 1, 'E) 1'                                    ; PSF sampling
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

    printf, 1, '0) sersic'                               ; Shape
    printf, 1, '1) '+posx1+' '+posy1+' '+strn(tfreepos[0])+' '+strn(tfreepos[0]) ; X and Y positions
    printf, 1, '3) '+mag1+' '+strn(tfreemag[0])          ; Magnitude
    printf, 1, '4) '+size1+' '+strn(tfreesize[0])        ; Half size
    printf, 1, '5) '+index1+' '+strn(tfreesersic[0])     ; Sersic index
    printf, 1, '9) '+ratio1+' '+strn(tfreeratio[0])      ; Axis ratio
    printf, 1, '10) '+angle1+' '+strn(tfreeangle[0])     ; Angle
    printf, 1, 'Z) 0'                                    ; Option

    if keyword_set(double_sersic) then begin
    printf, 1, '0) sersic'                               ; Shape
    printf, 1, '1) '+posx2+' '+posy2+' '+strn(tfreepos[1])+' '+strn(tfreepos[1]) ; X and Y positions
    printf, 1, '3) '+mag2+' '+strn(tfreemag[1])          ; Magnitude
    printf, 1, '4) '+size2+' '+strn(tfreesize[1])        ; Half size
    printf, 1, '5) '+index2+' '+strn(tfreesersic[1])     ; Sersic index
    printf, 1, '9) '+ratio2+' '+strn(tfreeratio[1])      ; Axis ratio
    printf, 1, '10) '+angle2+' '+strn(tfreeangle[1])     ; Angle
    printf, 1, 'Z) 0'                                    ; Option
    endif

    if keyword_set(add_psf) then begin
    printf, 1, '0) psf'                                  ; Shape
    printf, 1, '1) '+posx1+' '+posy1+' '+strn(tfreepos[0])+' '+strn(tfreepos[0]) ; X and Y positions
    printf, 1, '3) '+mag1+' '+strn(tfreemag[0])          ; Magnitude
    printf, 1, 'Z) 0'                                    ; Options
    endif

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

    if keyword_set(double_sersic) then begin
        params = { $
            dx1:!values.f_nan, dy1:!values.f_nan, dx2:!values.f_nan, dy2:!values.f_nan, $
            radius1:!values.f_nan, radius2:!values.f_nan, $
            angle1:!values.f_nan, angle2:!values.f_nan, $
            axis_ratio1:!values.f_nan, axis_ratio2:!values.f_nan, $
            flux1:!values.f_nan, flux2:!values.f_nan, $
            index1:!values.f_nan, index2:!values.f_nan, chi2:!values.f_nan $
        }

        if success then begin
            pos1 = [dogalfit2_read_param(hdr, '1_XCENT'), $
                    dogalfit2_read_param(hdr, '1_YCENT')]
            pos2 = [dogalfit2_read_param(hdr, '2_XCENT'), $
                    dogalfit2_read_param(hdr, '2_YCENT')]

            params.dx1 = timgsize[0]/2+1 - pos1[0]
            params.dy1 = timgsize[1]/2+1 - pos1[1]
            params.dx2 = timgsize[0]/2+1 - pos2[0]
            params.dy2 = timgsize[1]/2+1 - pos2[1]

            params.radius1     = dogalfit2_read_param(hdr, '1_RE')
            params.axis_ratio1 = dogalfit2_read_param(hdr, '1_AR')
            params.angle1      = dogalfit2_read_param(hdr, '1_PA')
            params.index1      = dogalfit2_read_param(hdr, '1_N')
            tmag1              = dogalfit2_read_param(hdr, '1_MAG')
            params.flux1 = 10d0^(-0.4*(tmag1 - magzp))

            params.radius2     = dogalfit2_read_param(hdr, '2_RE')
            params.axis_ratio2 = dogalfit2_read_param(hdr, '2_AR')
            params.angle2      = dogalfit2_read_param(hdr, '2_PA')
            params.index2      = dogalfit2_read_param(hdr, '2_N')
            tmag2              = dogalfit2_read_param(hdr, '2_MAG')
            params.flux2 = 10d0^(-0.4*(tmag2 - magzp))

            params.chi2 = dogalfit2_read_param(hdr, 'CHI2NU')
        endif
    endif else begin
        params = { $
            dx:!values.f_nan, dy:!values.f_nan, $
            radius:!values.f_nan, angle:!values.f_nan, axis_ratio:!values.f_nan, $
            flux:!values.f_nan, index:!values.f_nan, $
            chi2:!values.f_nan $
        }

        if success then begin
            pos1 = [dogalfit2_read_param(hdr, '1_XCENT'), $
                    dogalfit2_read_param(hdr, '1_YCENT')]

            params.dx = timgsize[0]/2+1 - pos1[0]
            params.dy = timgsize[1]/2+1 - pos1[1]

            params.radius     = dogalfit2_read_param(hdr, '1_RE')
            params.axis_ratio = dogalfit2_read_param(hdr, '1_AR')
            params.angle      = dogalfit2_read_param(hdr, '1_PA')
            params.index      = dogalfit2_read_param(hdr, '1_N')
            tmag1             = dogalfit2_read_param(hdr, '1_MAG')
            params.flux = 10d0^(-0.4*(tmag1 - magzp))

            params.chi2 = dogalfit2_read_param(hdr, 'CHI2NU')
        endif
    endelse

    if keyword_set(cleanup) then begin
        spawn, 'rm -f galfit.01'
        spawn, 'rm -f fit.log'
        if ~keyword_set(model) then spawn, 'rm -f '+tmp_out_file
        spawn, 'rm -f '+output+'.galfit.out'
        spawn, 'rm -f '+output+'.galfit.conf'
        spawn, 'rm -f '+output+'.galfit.const'
    endif
end
