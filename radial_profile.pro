; Build a radial profile from an image
;
; Arguments:
;  - img: the image to analyse
;
; Keyword:
;  - area: [output] number of pixels per radial bin
;  - integrated: set this keyword to generate the integrated profile
;  - normalized: set this keyword to normalize the generated profile wrt its maximum value
;
function radial_profile, img, area=area, integrated=integrated, normalized=normalized
    simg = size(img)
    npix = simg[1]/2
    
    area = fltarr(npix+1)
    area[0] = 1.0
    dmean = fltarr(npix+1)
    if keyword_set(integrated) then begin
        for d=1, npix do begin
            m = circular_mask(2*npix+1, 0, d)
            area[d] = total(m)
            dmean[d] = !dpi*d^2*total(img*m)
        endfor
    endif else begin
        dmean[0] = img[npix,npix]
        for d=1, npix do begin
            m = circular_mask(2*npix+1, 0, d)*circular_mask(2*npix+1, 0, d-1, /invert)
            area[d] = total(m)
            dmean[d] = total(img*m)
        endfor
    endelse
    
    dmean /= area
    
    if keyword_set(normalized) then return, dmean/max(dmean) else return, dmean
end

