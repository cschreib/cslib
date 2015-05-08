function lsun2mag, lam, lum
    Mpc = 3.0856d22
    Lsol = 3.839d26
    uJy = 1.0d32
    c = 2.9979d14
    factor = uJy*Lsol/(c*4.0*!dpi*Mpc*Mpc);

    d = 10.0/1d6
    return, -2.5*alog10(factor*lam*lum/(d*d)) + 23.9
end
