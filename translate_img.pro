; Translate an image in the 2D plane
;
; Arguments:
;  - img: the image to translate
;  - dx: the offset in 'x' coordinate (horizontal)
;  - dy: the offset in 'y' coordinate (vertical)
;
; Keywords:
;  - fill: value to use when there is no original data (default: 0)
;
function translate_img, img, tdx, tdy, fill=fill
    dx = long(round(tdx))
    dy = long(round(tdy))
    if dx eq 0 and dy eq 0 then return, img
    
    if ~provided(fill) then fill = 0.0
    timg = img*0.0 + fill
    
    si = size(img)
    sx = si[1]
    sy = si[2]
    
    
    if dx lt 0 then begin
        tx0 = 0
        ox0 = -dx
        tx1 = sx-1 + dx
        ox1 = sx-1
    endif else begin
        tx0 = dx
        ox0 = 0
        tx1 = sx-1
        ox1 = sx-1 - dx
    endelse
    
    if dy lt 0 then begin
        ty0 = 0
        oy0 = -dy
        ty1 = sy-1 + dy
        oy1 = sy-1
    endif else begin
        ty0 = dy
        oy0 = 0
        ty1 = sy-1
        oy1 = sy-1 - dy
    endelse
    
    timg[tx0:tx1, ty0:ty1] = img[ox0:ox1, oy0:oy1]
    
    return, timg
end
