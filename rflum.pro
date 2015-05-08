; Compute rest-frame luminosities by interpolating observed photometry.
;
; Arguments:
;  - lam: array of wavelengths corresponding to observed bands
;  - sed: flux observered at each wavelength in uJy
;  - z: redshift of the sources
;  - rfs: rest-frame wavelengths at which to compute the rest-frame luminosity
;
; Keywords:
;  - cosmo: cosmology to use to convert observed to rest-frame
;  - extrapol: set this keyword to allow extrapolations. If not set, rest-frame wavelengths that
;              would require extrapolation generate NaN luminosities.
;  - magnitude: set this keyword to return the result in magnitudes
;  - distance: set this keyword to get true rest-frame luminosity. If not set, returns simply
;              the interpolation of the observed SED at the redshifted wavelengths.
;
function rflum, lam, sed, z, rfs, cosmo=cosmo, extrapol=extrapol, magnitude=magnitude, distance=distance
    compile_opt idl2
    
    if ~keyword_set(distance) then begin
        rflam = lam/(1.0+z)
        idok = where(sed gt 0.0, cnt)
        if cnt eq 0 then return, replicate(sed[0]*!values.f_nan, n_elements(rfs))
        
        if keyword_set(extrapol) then begin
            res = interpol(sed[idok], rflam[idok], rfs)
        endif else begin
            res = replicate(sed[0]*!values.f_nan, n_elements(rfs))
            mirf = min(rflam[idok]) & marf = max(rflam[idok])
            idin = where(rfs ge mirf and rfs le marf, cnt)
            if cnt ne 0 then res[idin] = interpol(sed[idok], rflam[idok], rfs[idin])
        endelse
    
        if keyword_set(magnitude) then begin
            res = -2.5*alog10(res) + 23.9
        endif
    endif else begin
        if ~provided(cosmo) then cosmo = cosmo(/wmap)
        
        Mpc = 3.0856d22 ; [m/Mpc]
        Lsol = 3.839d26 ; [W/Lsol]
        uJy = 1d32      ; [uJy/(W.m-2.Hz-1)]
        c = 2.9979d14   ; [um.s-1]
        
        d = Mpc*lumdist(z, H0=cosmo.H0, Omega_M=cosmo.o_m, Lambda0=cosmo.o_l, /silent)
        rfsed = sed/(uJy*(lam/c))*4.0*!dpi*d^2
        rflam = lam/(1.0+z)
        
        idok = where(rfsed gt 0.0, cnt)
        if cnt lt 2 then return, replicate(rfsed[0]*!values.f_nan, n_elements(rfs))
        
        if keyword_set(extrapol) then begin
            res = interpol(rfsed[idok], rflam[idok], rfs)
        endif else begin
            res = replicate(rfsed[0]*!values.f_nan, n_elements(rfs))
            mirf = min(rflam[idok]) & marf = max(rflam[idok])
            idin = where(rfs ge mirf and rfs le marf, cnt)
            if cnt ne 0 then res[idin] = interpol(rfsed[idok], rflam[idok], rfs[idin])
        endelse
        
        res *= rfs/c
    
        if keyword_set(magnitude) then begin
            res = -2.5*alog10(uJy*res/(4.0*!dpi*(10e-6*Mpc)^2)) + 23.9
        endif else begin
            res /= Lsol
        endelse
    endelse
    
    return, res
end
