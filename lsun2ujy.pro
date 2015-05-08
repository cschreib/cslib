function lsun2uJy, z, lam, lum, cosmo=cosmo
    if ~provided(cosmo) then cosmo = get_cosmo(/std)

    Mpc = 3.0856d22
    Lsol = 3.839d26
    uJy = 1.0d32
    c = 2.9979d14
    factor = uJy*Lsol/(c*4.0*!dpi*Mpc*Mpc);

    d = lumdist(z, H0=cosmo.H0, omega_m=cosmo.o_m, Lambda0=cosmo.o_l, /silent)
    return, factor*(1.0 + z)*lam*lum/(d*d)
end
