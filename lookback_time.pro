function fct_lkbckt, z
    common lookback_time_common, ccosmo

    return, (ccosmo.o_m*(1d0+z)^3 + ccosmo.o_l + ccosmo.o_r*(1d0+z)^2)^(-0.5)/(1d0+z)
end

; Compute the lookback time at a particular redshift (in Gyr).
; This is the amount of time in the past that one is looking at when considering an object located
; at the provided redshift.
;
; Arguments:
;  - z: the redshift(s) at which to compute the lookback time
;
; Keywords:
;  - cosmo: the set of cosmological parameters (see cosmo())
;  - normalized: set this keyword to return the lookback time divided by the age of the universe
;
function lookback_time, z, cosmo=cosmo, normalized=normalized
    compile_opt idl2
    common lookback_time_common, ccosmo
    if ~provided(cosmo) then cosmo = get_cosmo()
    ccosmo = cosmo

    t_look = 0*z - 1
    idnz = where(z gt 0.0, cnt)
    if cnt ne 0 then begin
        t_look[idnz] = (3.09d0/(cosmo.H0*3.155d-3))*qromb('fct_lkbckt', 0d0, z[idnz])

        if keyword_set(normalized) then begin
            auniv = (3.09d0/(cosmo.H0*3.155d-3))*qromb('fct_lkbckt', 0d0, 1000.0)
            t_look[idnz] /= auniv
        endif
    endif

    return, t_look
end
