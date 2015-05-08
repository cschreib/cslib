; Return the weight of an upper limit in a chi2 merit function.
; Note that the analytical relation is numerically imprecise, and an asymptotic expression should
; be used below -3. This function contains this approximation, which introduces at most an error of
; 0.3%. Above 4, IDL's numerical precision is not sufficient to trace the actual evolution of the
; function, hence it is simply set to 0.
; Also note that this function can also give the weight of a *lower* limit simply by changing the
; sign of its argument. See below for more information.
;
; Arguments:
;  - x: weighted deviate from the upper limit. Must be positive if the model is below the upper
;       limit, and negative when it is above. The value is assumed to be weighted by the error on
;       the limit: the more the error is important, the less the limit is strict and the more likely
;       it is to be crossed. If you want to impose a strict limit, use a very low error (but not 0).
;       Summarizing: if comparing a model 'ym' to a measured upper limit 'yu' with error 'ye', then
;       'x' is assumed to be '(yu - ym)/ye'. In the case of a lower limit 'yl', simply change the
;       sign and use '(ym - yl)/ye'.
;
function limweight, x
    ; Analytical formula:
    ;return, -alog(0.5 + 0.5*erf(x))

    ; Approximated version that is numerically stable
    res = x*0.0

    idl = where(x lt -3.0, cnt)
    if cnt ne 0 then res[idl] = x[idl]^2 + 2d0*alog(-2d0*sqrt(!dpi/2d0)*x[idl])

    idu = where(x ge -3.0 and x lt 4.0, cnt)
    if cnt ne 0 then res[idu] = -2d0*alog(5d-1*(1d0 + erf(x[idu]/sqrt(2))))

    return, res
end
