function codist_int, z
    common codist_cmn, om, ol
    return, 1.0/sqrt(om*(1.0 + z)^3 + ol)
end

; Compute the comoving distance of an object given its redshift
function codist, z, o_m=o_m, o_l=o_l, H0=H0
    common codist_cmn, om, ol
    
    if ~provided(H0)  then H0  = 70.0
    if ~provided(o_m) then o_m = 0.3
    if ~provided(o_l) then o_l = 0.7

    om = o_m
    ol = o_l
    
    return, (3e5/H0)*qromb('codist_int', 0.0, z)
end
