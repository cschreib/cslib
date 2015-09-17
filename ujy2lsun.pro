function uJy2lsun, z, lam, flx, cosmo=cosmo
    if ~provided(cosmo) then cosmo = get_cosmo(/std)

    Mpc = 3.0856d22
    Lsol = 3.839d26
    uJy = 1.0d32
    c = 2.9979d14
    factor = c*4.0*!dpi*Mpc*Mpc/(uJy*Lsol)

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

    return, factor*flx*d*d/lam
end

; Fbb = Mdust*K*(l/l0)^b*B(l,T)/D2
; Lbb = factor*Fbb*D2/l
;     = (c*4.0*!dpi/Lsol)*Mdust*(K/l0)*(l/l0)^(b-1)*B(l,T)

    ; factor [(um/s)*Lsun/W]
    ; [factor]*[kg]*[m2/kg/um]*[W/m2]
    ;

    ; B: 2*h*nu3/c2/(exp(-h*nu/(kb*T)) - 1)
    ;    (2*h*c/l3)/(exp(-h*nu/(kb*T)) - 1)
    ;    4d-7/(l [um])^3/(...)
    ;
    ; [h*nu3/c2] = [J*s3/s3/m2] = [J/m2] = [W*s/m2] = [W/m2/Hz]
