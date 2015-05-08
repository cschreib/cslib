
pro makepsf, fimg, ra, dec, hsize=hsize, radius=radius, beam=beam, recenter=recenter
    if ~provided(radius) then radius = 0
    if ~provided(hsize) then hsize = 64
    
    cov = readfits(fimg+'_cov.fits')
    
    idcov = where(cov gt 0.0)
    scov = idcov[sort(cov[idcov])]
    gcov = 0.15*cov[scov[n_elements(scov)*0.9]]
    
    img = readfits(fimg+'_sci.fits', hdr)
    extast, hdr, astr
    ad2xy, ra, dec, astr, x, y
    idok = where(cov[x,y] gt gcov, ncov)
    
    dostack_xy, img, x[idok], y[idok], stackm, size=hsize, /resampling
    
    idbg = where(circular_mask(2*hsize+1, 0, 0.6*hsize) gt 0.5)
    stackm -= median(stackm[idbg])
    
    if radius ne 0 then begin
        stackm *= circular_mask(2*hsize+1, 0, radius)
    endif
    
    if keyword_set(recenter) then begin
        ma = max(stackm, idm)
        xm = (idm mod (2*hsize+1))
        ym = (idm / (2*hsize+1))
        dx = hsize - xm
        dy = hsize - ym
        print, 'recenter: ', dx, dy
        
        stackm = translate_img(stackm, dx, dy, fill=0.0)
    endif
    
    if keyword_set(beam) then begin
        stackm /= stackm[hsize,hsize]
    endif
    
    writefits, fimg+'_psf_cs.fits', stackm
end
