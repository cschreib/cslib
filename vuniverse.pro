; Compute the comoving observable volume of the universe up to a certain redshift (in Mpc^3).
;
; Arguments:
;  - z: the redsfhit(s) at which to compute the volume
;
; Keywords:
;  - cosmo: the set of cosmological parameters (see cosmo())
;
function vuniverse, z, H0=H0, cosmo=cosmo
    compile_opt idl2
    if ~provided(cosmo) then cosmo = get_cosmo(/std)
    return, (4.0d/3.0d)*!dpi*(lumdist(z, H0=cosmo.H0, Omega_M=cosmo.o_m, Lambda0=cosmo.o_l, /silent)/(1.0 + z))^3
end
