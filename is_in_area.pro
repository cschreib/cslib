function sign, p1x, p1y, p2x, p2y, p3x, p3y
    return, (p1x - p3x)*(p2y - p3y) - (p2x - p3x)*(p1y - p3y)
end

; For each source, return 1 if it is located inside the area drawn by the first set of coordinates.
;
; Arguments:
;  - ara, adec: right ascension and declination of the sources that define the area
;  - ra, dec: right ascension and declination of each source
;
function is_in_area, ara, adec, ra, dec
    triangulate, ara, adec, tri
    ntri = n_elements(tri[0,*])

    inarea = intarr(n_elements(ra))
    for i=0, ntri-1 do begin
        t1x = ara[tri[0,i]]
        t2x = ara[tri[1,i]]
        t3x = ara[tri[2,i]]
        t1y = adec[tri[0,i]]
        t2y = adec[tri[1,i]]
        t3y = adec[tri[2,i]]

        s1 = sign(ra, dec, t1x, t1y, t2x, t2y) lt 0
        s2 = sign(ra, dec, t2x, t2y, t3x, t3y) lt 0
        s3 = sign(ra, dec, t3x, t3y, t1x, t1y) lt 0

        intri = s1 eq s2 and s2 eq s3
        inarea = inarea or intri
    endfor

    return, inarea
end
