function ujy2cgs, lam, flx
    toerg = 1.0d-29  ; 1 uJy in erg/s/cm2/Hz
    c = 2.9979d8    ; speed of light in m/s
    tometer = 1e-6  ; 1 um in meter
    toangstrom = 1e10 ; 1 meter in Angstrom

    ; 1 uJy to erg/s/cm2/A
    factor = toerg*c/(lam*tometer)^2/toangstrom

    return, factor*flx
end
