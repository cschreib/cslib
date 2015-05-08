function psffit_fun, x, p, psf=psf
    return, psf[x]*p[0] + p[1]
end

; Compute the flux of a source (or several sources) using PSF fitting and assuming a constant
; background level.
;
; Note: uses 'mpfit' internally. The reported error on the extracted flux is simply the formal
; error from the non linear fitting procedure.
;
; Arguments:
;  - map: the image on which the sources resides
;  - psf: the point spread function that will be used for the fit
;
; Keywords:
;  - pos: the position of the sources' central pixel within the image. If omitted, the function
;         assumes that there is a single source at the center of the image.
;  - rms: the error on the image values. If omitted, all pixels have the same weight in the fit.
;  - psffrac: the fraction of the PSF that will be fitted. It is sometimes desirable to crop the
;             PSF so that the fitting does not try to fit the tails of the PSF that are blended with
;             the background.
;  - recenter: set this keyword to allow recentering of the psf to the brightest central pixel of
;              the cutout.
;  - max_recenter: maximum number of pixel offset to allow when recentering the PSF.
;  - dpos: [output] if 'recenter' is set, holds the offsets in pixels of the new center
;
function psffit, map, psf, pos=pos, rms=rms, psffrac=psffrac, appcor=appcor, recenter=recenter, $
    max_recenter=max_recenter, dpos=dpos
    
    sizep = size(psf)
    npx = sizep[1]/2
    
    if ~provided(rms) then rms = map*0.0 + 1.0
    if keyword_set(recenter) then begin
        if ~provided(max_recenter) then begin
            max_recenter = 2*npx
        endif else if max_recenter eq 0 then begin
            recenter = 0
        endif
    endif
    if ~provided(pos) then begin
        pos = fltarr(1,2)
        sizem = size(map)
        pos[0] = [sizem[1]/2, sizem[2]/2]
    endif else begin
        if n_elements(pos) eq 2 then pos = areplicate(pos, 1)
    endelse
    
    if ~provided(psffrac) then psffrac = 1.0
    if psffrac lt 1.0 then begin
        ; If asked, crop the PSF to a certain fraction from its center
        ncor = ceil(npx*psffrac)
        dn = npx - ncor
        xfit = lindgen(2*npx+1, 2*npx+1)
        xfit = reform(xfit[dn:2*npx - dn, dn:2*npx - dn])
    endif else begin
        xfit = lindgen((2*npx+1)^2)
    endelse
    
    sizepos = size(pos)
    npos = sizepos[1]
    
    if keyword_set(recenter) and arg_present(dpos) then dpos = lonarr(npos,2)
    
    res = replicate({flux:0.0, fluxe:0.0, background:0.0, backgrounde:0.0}, npos)
    for i=0, npos-1 do begin
        ; Get a cutout from the flux map and the error map
        submap = map[pos[i,0]-npx:pos[i,0]+npx, pos[i,1]-npx:pos[i,1]+npx]
        suberr = rms[pos[i,0]-npx:pos[i,0]+npx, pos[i,1]-npx:pos[i,1]+npx]
        
        if keyword_set(recenter) then begin
            ; If recentering is allowed, move the PSF where the brightest pixel is
            mav = max(submap[xfit], mid)
            mid = xfit[mid]
            mx = (mid mod (2*npx+1)) - npx
            my = mid/(2*npx+1) - npx
            
            if abs(mx)+abs(my) le max_recenter then begin
                if arg_present(dpos) then begin
                    dpos[i,0] = mx
                    dpos[i,1] = my
                endif
                
                submap = map[pos[i,0]+mx-npx:pos[i,0]+mx+npx, pos[i,1]+my-npx:pos[i,1]+my+npx]
                suberr = rms[pos[i,0]+mx-npx:pos[i,0]+mx+npx, pos[i,1]+my-npx:pos[i,1]+my+npx]
            endif
        endif
        
        ; Try to fit the PSF
        fres = mpfitfun('psffit_fun', xfit, submap[xfit], suberr[xfit], [1.0, 0.0], functargs={psf:psf}, $
            perror=errs, status=status, /quiet)
        
        if status ge 1 then begin
            res[i].flux = fres[0]
            res[i].fluxe = errs[0]
            res[i].background = fres[1]
            res[i].backgrounde = errs[1]
        endif
    endfor
    
    return, res
end

