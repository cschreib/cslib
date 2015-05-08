; Return the area of the surface that encompasses all the provided coordinates (in degrees^2).
;
; Arguments:
;  - ra, dec: right ascension and declination of each source
;
function get_area, ra, dec
    triangulate, ra, dec, tri
    ntri = n_elements(tri[0,*])
    
    gcirc, 2, ra[tri[0,*]], dec[tri[0,*]], ra[tri[1,*]], dec[tri[1,*]], e1
    gcirc, 2, ra[tri[1,*]], dec[tri[1,*]], ra[tri[2,*]], dec[tri[2,*]], e2
    gcirc, 2, ra[tri[2,*]], dec[tri[2,*]], ra[tri[0,*]], dec[tri[0,*]], e3
    
    p = 0.5*(e1+e2+e3)
    return, total(sqrt(p*(p-e1)*(p-e2)*(p-e3)))/3600.0^2 
end
