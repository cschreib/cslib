; Return the volume of the universe between z=zmin and z=zmax, for an area of skyfrac square degrees
function vslice, zmin, zmax, skyfrac, cosmo=cosmo
    frac = 1.0
    if provided(skyfrac) then frac = skyfrac*(!dpi/180.0)^2/(4.0*!dpi)

    return, frac*(vuniverse(zmax, cosmo=cosmo) - vuniverse(zmin, cosmo=cosmo))
end
