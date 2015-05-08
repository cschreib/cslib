; Smooth the provided image with a gaussian kernel of variable radius
;
; Arguments:
;  - img: the image to smooth out
;  - rad: the radius of the gaussian kernel (exp(-0.5*(r/rad)^2))
;
function gsmooth, img, rad
    g = genprofile(3*rad, 'exp(-0.5*(r/('+strn(rad)+'))^2)', /radial)
    g /= total(g)
    return, convol(img, g)
end
