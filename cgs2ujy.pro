function cgs2ujy, lam, flx
    toerg = 1.0d-29  ; 1 uJy in erg/s/cm2/Hz
    c = 2.9979d8    ; speed of light in m/s
    tometer = 1e-10  ; 1 Angstrom in meter

    ; 1 uJy to erg/s/cm2/A
    factor = toerg*c/(lam*tometer)^2*tometer

    return, flx/factor
end
