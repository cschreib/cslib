; Generate a 2D image from a mathematical function, either of the cartesian 'x' and 'y' coordinates
; (default) or of the polar 'r' and 'theta' coordinates (/radial).
;
; Arguments:
;  - dim: the dimension of the image to create. If dim is a scalar, then the image will be created
;         as a 2*dim+1 x 2*dim+1 array. If dim is a vector of 2 elements, then the image will be
;         created as a 2*dim[0]+1 x 2*dim[1]+1 array.
;  - expr: a string expression to evaluate on each pixel of the image. This expression may only
;          use the 'x' and 'y' pre-defined variables (and any mathematical function of course).
;          If 'radial' is set (see below), one may also use the polar coordinates 'r' and 'theta'.
;          Optionally, if 'param' is set, one can access additional parameters using 'p'.
;          'p' will contain the value(s) that you put in 'param'.
;
; Keywords:
;  - radial: by default, only cartesian coordiantes are allowed in 'expr'. If this keyword is set,
;            the 'r' and 'theta' polar coordinates are also generated and can be used along with
;            'x' and 'y'.
;  - double: set this keyword to generate double precision data instead of single precision.
;  - param: use this variable to provide additional parameters to the expression.
;
function genprofile, tdim, expr, radial=radial, double=double, param=param
    if n_elements(tdim) eq 1 then dim = [tdim, tdim] else dim = tdim
    
    if keyword_set(double) then begin
        tx = dindgen(2*dim[0]+1) - dim[0]
        ty = dindgen(2*dim[1]+1) - dim[1]
    endif else begin
        tx = findgen(2*dim[0]+1) - dim[0]
        ty = findgen(2*dim[1]+1) - dim[1]
    endelse
    
    x  = tx       # (ty*0+1)
    y  = (tx*0+1) # ty
    
    if keyword_set(radial) then begin
        r = sqrt(x^2 + y^2)
        theta = atan(x, y)
    endif

    if provided(param) then p = param    
    void = execute('img = '+expr)
    
    return, img
end
