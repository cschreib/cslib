pro myarrow, x, y, color=color, hsize=hsize, filled=filled, noclip=noclip, leftright=leftright, _extra=extra
    if ~provided(thick) then thick=1
    if ~provided(hsize) then hsize=[1,1]
    if n_elements(hsize) eq 1 then hsize=[hsize,hsize]

    ; Convert line to screen coordinates
    d = convert_coord(x, y, /data, /to_device)
    dx = reform(d[0,*])
    dy = reform(d[1,*])

    ; Compute angle
    n = n_elements(x)
    a = atan(dx[n-1]-dx[n-2], dy[n-1]-dy[n-2])

    ; Define arrow
    ax = [-0.5, 0, +0.5]
    ay = [-1.5, 0, -1.5]
    a2x = [-0.5, 0, +0.5]
    a2y = [1.5, 0, 1.5]

    ; Modify width
    ax *= hsize[0]
    ay *= hsize[1]
    a2x *= hsize[0]
    a2y *= hsize[1]

    ; Rotate arrow
    rax =  cos(a)*ax + sin(a)*ay
    ray = -sin(a)*ax + cos(a)*ay
    ra2x =  cos(a)*a2x + sin(a)*a2y
    ra2y = -sin(a)*a2x + cos(a)*a2y

    ; Convert arrow to device coordinates
    rax *= !d.x_ch_size
    ray *= !d.x_ch_size
    ra2x *= !d.x_ch_size
    ra2y *= !d.x_ch_size

    ; Move to extremety of line
    rax += dx[n-1]
    ray += dy[n-1]
    ra2x += dx[0]
    ra2y += dy[0]

    ; Close the polygon
    rax = [rax, rax[0]]
    ray = [ray, ray[0]]
    ra2x = [ra2x, ra2x[0]]
    ra2y = [ra2y, ra2y[0]]

    ; Shorten the line
    if keyword_set(filled) then begin
        ox = dx
        oy = dy

        ld = sqrt((dx[n-1] - dx[n-2])^2 + (dy[n-1] - dy[n-2])^2) > 0
        q = 1.0 - 1.5*hsize[1]*thick*!d.x_ch_size/ld
        dx[n-1] = dx[n-2] + q*(dx[n-1] - dx[n-2])
        dy[n-1] = dy[n-2] + q*(dy[n-1] - dy[n-2])

        if keyword_set(leftright) then begin
            dx[0] = ox[1] + q*(ox[0] - ox[1])
            dy[0] = oy[1] + q*(oy[0] - oy[1])
        endif
    endif

    ; Convert back line to data coordinates
    d = convert_coord(dx, dy, /device, /to_data)

    ; Plot the line
    oplot, d[0,*], d[1,*], color=color, noclip=noclip, _extra=extra

    ; Plot the arrow
    if keyword_set(filled) then begin
        polyfill, rax, ray, color=color, noclip=noclip, /device
    endif else begin
        ; Convert back arrow to data coordinates
        d = convert_coord(rax, ray, /device, /to_data)

        oplot, d[0,0:2], d[1,0:2], color=color, noclip=noclip, _extra=extra
    endelse

    if keyword_set(leftright) then begin
        if keyword_set(filled) then begin
            polyfill, ra2x, ra2y, color=color, noclip=noclip, /device
        endif else begin
            ; Convert back arrow to data coordinates
            d = convert_coord(ra2x, ra2y, /device, /to_data)

            oplot, d[0,0:2], d[1,0:2], color=color, noclip=noclip, _extra=extra
        endelse
    endif
end
