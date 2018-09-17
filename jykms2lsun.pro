function jykms2lsun, z, lam, flx
    ; fgcs = uJy2cgs(lam, flx*1e6*(lam*1d4/3d5))

    toerg = 1.0d-29  ; 1 uJy in erg/s/cm2/Hz
    tometer = 1e-6  ; 1 um in meter
    fgcs = flx*toerg/(lam*tometer)*1e6*1e3

    return, cgs2lum(z, fgcs)/3.9d33
end
