function calzetti2000, lam, Rv=Rv
    if n_elements(Rv) eq 0 then Rv = 4.05

    curve = lam*0
    idl = where(lam le 0.63, cnt)
    if cnt ne 0 then curve[idl] =  2.659*(-1.857 + 1.04/lam[idl]) + Rv
    idl = where(lam gt 0.63, cnt)
    if cnt ne 0 then curve[idl] =  2.659*(-2.156 + 1.509/lam[idl] - 0.198/lam[idl]^2 + 0.011/lam[idl]^3) + Rv

    if n_elements(lam) eq 1 then curve = curve[0]

    return, curve
end
