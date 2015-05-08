; Generate a set of cosmological parameters.
; Default: H0 = 70, matter density (o_m) = 0.3, cosmological constant density (o_l) = 0.7.
;          No curvature (k), no radiation (o_r).
;
; Keywords:
;  - wmap: generate WMAP cosmology (H0=70, o_m=0.27, o_l=0.73, o_r=0.0)
;  - H0, o_m, o_l, o_r: specify explicitely a particular parameter (will override any other
;                       definition)
;
function get_cosmo, wmap=wmap, std=std, planck=planck, H0=H0, o_m=o_m, o_l=o_l, o_r=o_r
    c = {H0:70.0, o_m:0.3, o_l:0.7, o_r:0.0}

    if keyword_set(wmap) then begin
        c.o_m = 0.27
        c.o_l = 0.73
    endif else if keyword_set(planck) then begin
        c.H0  = 67.3
        c.o_m = 0.315
        c.o_l = 0.685
    endif else if keyword_set(std) then begin
        c.o_m = 0.3
        c.o_l = 0.7
    endif

    if provided(H0)  then c.H0  = H0
    if provided(o_m) then c.o_m = o_m
    if provided(o_l) then c.o_l = o_l
    if provided(o_r) then c.o_r = o_r

    return, c
end
