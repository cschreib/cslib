function mag, flux, zp
    if ~provided(zp) then zp = 23.9
    return, -2.5*alog10(flux) + zp
end
