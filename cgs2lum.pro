function cgs2lum, z, flx, cosmo=cosmo
    if ~provided(cosmo) then cosmo = get_cosmo(/std)

    Mpc = 3.0856d24
    factor = 4.0*!dpi*Mpc*Mpc

    if n_elements(z) gt 10000L then begin
        zx = rgen(0.001,10,500)
        dx = lumdist(zx, H0=cosmo.H0, omega_m=cosmo.o_m, Lambda0=cosmo.o_l, /silent)
        d = 10d0^interpol(alog10(dx), zx, z)
    endif else if n_elements(z) eq 1 then begin
        d = lumdist(z[0], H0=cosmo.H0, omega_m=cosmo.o_m, Lambda0=cosmo.o_l, /silent)
    endif else begin
        d = dblarr(n_elements(z))
        idg = where(z gt 0, cnt)
        if cnt ne 0 then begin
            d[idg] = lumdist(z, H0=cosmo.H0, omega_m=cosmo.o_m, Lambda0=cosmo.o_l, /silent)
        endif
    endelse

    return, factor*flx*d*d
end
