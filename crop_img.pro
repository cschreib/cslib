; Crop the provided image to the requested half size from its center.
; This function can also enlarge images, filling the gaps with an arbitrary value.
;
; Arguments:
;  - img: the image to crop
;  - hsize: the requested half size (result will be (2*hsize+1) x (2*hsize+1))
;
; Keywords:
;  - fill: the value to use when there is no original data
;
function crop_img, img, hsize, fill=fill
    if ~provided(fill) then fill = 0.0
    oimg = replicate(fill, 2*hsize+1, 2*hsize+1)
    
    si = size(img)
    sx = si[1] & sy = si[2]
    s = 2*hsize+1
    
    if s lt sx then begin
        x0 = 0
        ox0 = (sx - s)/2
        sx = s
    endif else begin
        x0 = (s - sx)/2
        ox0 = 0
    endelse
    if s lt sy then begin
        y0 = 0
        oy0 = (sy - s)/2
        sy = s
    endif else begin
        y0 = (s - sy)/2
        oy0 = 0
    endelse
    
    oimg[x0:x0+sx-1,y0:y0+sy-1] = img[ox0:ox0+sx-1,oy0:oy0+sy-1]
    
    return, oimg
end
