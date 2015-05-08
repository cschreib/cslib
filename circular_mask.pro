; Generate a circular mask in a 2D array.
; All the pixels that are within 'radius' pixels of 'center' will be associated a value of 1, and
; the others will be 0. Simple interpolation is made for pixels that lie on the boundary of the
; circle. If the 'invert' keyword is set, the values are reversed (0 in the circle, 1 outside).
; 
; Arguments:
;  - ns: size of the 2D array to generate. If only 1 size is given, it will be used for both x and y
;        axes. If 2 sizes are provided, they will be used for x and y axes respectively.
;  - center: coordinate in pixel units of the center of the circle (2 values: x and y). Set this
;            value to 0 if you want the center of the circle to be that of the image. 
;  - radius: radius in pixel
;
; Keywords:
;  - invert: If set, the pixels inside the circle will be filled with 0, and those outside will be
;            filled by 1.
;  - double: If set, all calculations will be performed in double precision.
;  - sharp: If set, then no interpolation will be performed for the pixels near the boundary of the
;           circle. This will speed up the computation, but will decrease the quality of the output,
;           mostly for the small radii (around 5 pixels and lower).
;
function circular_mask, ns, center, radius, invert=invert, double=double, sharp=sharp
    if n_elements(ns) eq 1 then begin
        nx = ns
        ny = ns
    endif else begin
        nx = ns[0]
        ny = ns[1]
    endelse
    
    if keyword_set(double) then begin
        xdata = dindgen(nx)
        ydata = dindgen(ny)
    endif else begin
        xdata = findgen(nx)
        ydata = findgen(ny)
    endelse
    
    if n_elements(center) eq 1 then center = [(nx-1)/2.0, (ny-1)/2.0]
    
    px = (xdata+0.5) # (ydata*0+1)
    py = (xdata*0+1) # (ydata+0.5)
    
    if keyword_set(sharp) then begin
        mask = 1.0d*((px - center[0])^2 + (py - center[1])^2 le radius^2)
    endif else begin 
        mask0 = (px-0.5d - center[0])^2 + (py-0.5d - center[1])^2 le radius^2
        mask1 = (px+0.5d - center[0])^2 + (py-0.5d - center[1])^2 le radius^2
        mask2 = (px+0.5d - center[0])^2 + (py+0.5d - center[1])^2 le radius^2
        mask3 = (px-0.5d - center[0])^2 + (py+0.5d - center[1])^2 le radius^2
        
        mask = (mask0 + mask1 + mask2 + mask3)/4.0d
    endelse
    
    if keyword_set(invert) then mask = 1.0d - mask
    
    return, mask
end 
