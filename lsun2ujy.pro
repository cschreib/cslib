function lsun2uJy, z, lam, lum, cosmo=cosmo
    if ~provided(cosmo) then cosmo = get_cosmo(/std)

    Mpc = 3.0856d22
    Lsol = 3.839d26
    uJy = 1.0d32
    c = 2.9979d14
    factor = uJy*Lsol/(c*4.0*!dpi*Mpc*Mpc)

    if n_elements(z) gt 10000L then begin
        zx = rgen(0.001,10,500)
        dx = lumdist(zx, H0=cosmo.H0, omega_m=cosmo.o_m, Lambda0=cosmo.o_l, /silent)
        d = 10d0^interpol(alog10(dx), zx, z)
    endif else begin
        d = dblarr(n_elements(z))
        idg = where(z gt 0, cnt)
        if cnt ne 0 then begin
            d[idg] = lumdist(z, H0=cosmo.H0, omega_m=cosmo.o_m, Lambda0=cosmo.o_l, /silent)
        endif
    endelse

    return, factor*(1.0 + z)*lam*lum/(d*d)
end
