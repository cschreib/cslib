; m: mass of the central object in log Msun
; r: distance to the central object in kpc
; return velocity in km/s
function escape_velocity, m, r
    Msun = 1.989d30 ; Msun to kg
    kms = 1d-3 ; m/s to km/s
    G = 6.67d-11 ; [m3 / kg / s2]
    kpc = 3.0857d19 ; kpc to m
    return, kms*sqrt(2*G*Msun*10d0^m/(r*kpc))
end
