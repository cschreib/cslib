; Return the proper size of an object in kilo-parsecs. The object is seen at redshift 'z' within an
; angle 'angsize' in arcseconds.
;
; Arguments:
;  - z: the redshift of the source
;  - angsize: the angular size of the source in arcseconds
;
function propsize, z, angsize, cosmo=cosmo
    compile_opt idl2
    if ~provided(cosmo) then cosmo = get_cosmo(/std)

    return, (angsize/3.6)*(!dpi/180.0)*lumdist(z, H0=cosmo.H0, Omega_M=cosmo.o_m, Lambda0=cosmo.o_l, /silent)/(1.0+z)^2
end
