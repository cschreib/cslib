; Converts 1D or 2D arrays into 'binned' arrays, where each value of the input array is replaced
; by a pair of values that surround it. For example, if /interp is set:
;     (1, 2, 3, 4) -> (0.5, 1.5, 1.5, 2.5, 2.5, 3.5, 3.5, 4.5)
;
; If /interp is not set, the function duplicates the original array:
;     (1, 2, 3, 4) -> (1.0, 1.0, 2.0, 2.0, 3.0, 3.0, 4.0, 4.0)
;
; Arguments:
;  - data: the data to convert, can be a 1D or 2D array
; 
; Keywords:
;  - interp: if this keyword is omitted, the function does not perform any interpolation and just
;            repeats the values of the original array
;
function binify, data, interp=interp
    if n_params() eq 0 then begin
        print, "'binify' usage: result = binify(data, interp=interp)"
        return, -1
    endif
    
    s = size(data)
    if s[0] eq 1 then begin
        nelem = s[1]
        
        odata = fltarr(2*nelem)
        odata[0] = data[0]
        odata[2*nelem-1] = data[nelem-1]
        if keyword_set(interp) then begin
            odata[2*lindgen(nelem-1)+1] = 0.5*(data[lindgen(nelem-1)] + data[lindgen(nelem-1)+1])
            odata[2*lindgen(nelem-1)+2] = odata[2*lindgen(nelem-1)+1]
            
            odata[0] = odata[0] - (odata[1] - odata[0])
            odata[2*nelem-1] = odata[2*nelem-1] + (odata[2*nelem-1] - odata[2*nelem-2])
        endif else begin
            odata[2*lindgen(nelem-1)+1] = data[lindgen(nelem-1)]
            odata[2*lindgen(nelem-1)+2] = data[lindgen(nelem-1)+1]
        endelse
        return, odata
    endif else if s[0] eq 2 then begin
        nx = s[1]
        ny = s[2]
        
        odata = fltarr(2*nx, 2*ny)
        odata[0,*] = binify(reform(data[0,*]), interp=interp)
        odata[2*nx-1,*] = binify(reform(data[nx-1,*]), interp=interp)
        if keyword_set(interp) then begin
            for i=0, nx-2 do begin
                odata[2*i+1,*] = 0.5*(binify(reform(data[i,*]), interp=interp) + binify(reform(data[i+1,*]), interp=interp))
                odata[2*i+2,*] = odata[2*i+1,*]
            endfor
            
            odata[0,*] = odata[0,*] - (odata[1,*] - odata[0,*])
            odata[2*nx-1,*] = odata[2*nx-1,*] + (odata[2*nx-1,*] - odata[2*nx-2,*])
        endif else begin
            for i=0, nx-2 do begin
                odata[2*i+1,*] = binify(reform(data[i,*]),   interp=interp)
                odata[2*i+2,*] = binify(reform(data[i+1,*]), interp=interp)
            endfor
        endelse
        
        return, odata
    endif else begin
        print, 'error: binify: arrays of dimensions greater than 2 are not supported'
        return, 0
    endelse
end
