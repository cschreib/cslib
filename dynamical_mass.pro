; sigma: velocity dispersion (sigma, not FWHM) in km/s
; r: size of the object in kpc
; return mass in log Msun
function dynamical_mass, sigma=sigma, r=r, mass=mass, tosigma=tosigma, tomass=tomass
    Msun = 1.989d30 ; Msun to kg
    kms = 1d3 ; km/s to m/s
    G = 6.67d-11 ; [m3 / kg / s2]
    kpc = 3.0857d19 ; kpc to m
    if keyword_set(tosigma) then begin
        return, sqrt(10d0^mass*Msun*G/(r*kpc))/kms
    endif else begin
        return, alog10((sigma*kms)^2*(r*kpc)/G/Msun)
    endelse
end
