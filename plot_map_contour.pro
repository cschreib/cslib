pro plot_map_contour, img, src_ast, dst_ast, levels=levels, uselevels=uselevels, $
    range=range, nlevel=nlevel, sigma=sigma, binary=binary, _extra=extra, filled=filled, $
    fill_extra=fill_extra

    if ~provided(levels) or ~keyword_set(uselevels) then begin
        if keyword_set(binary) then begin
            levels = [0,1]
        endif else begin
            ido = where(img ne 0, cnt)
            if cnt eq 0 then return
            dm = 1.48*mad(img[ido])

            if ~provided(range) then begin
                mi = median(img[ido])+dm
                ma = percentile(img[ido], 0.99)
            endif else begin
                if keyword_set(sigma) then begin
                    mi = range[0]*dm
                    ma = range[1]*dm
                endif else begin
                    mi = range[0]
                    ma = range[1]
                endelse
            endelse

            if ~provided(nlevel) then begin
                nlevel = (ma - mi)/dm
            endif else begin
                dm = (ma - mi)/(nlevel-1)
            endelse

            if nlevel lt 1 then nlevel = 1

            levels = mi + dm*findgen(nlevel)
        endelse
    endif

    contour, img, /overplot, levels=levels, /path_data_coords, $
        path_xy=path, path_info=info, closed=0

    if n_elements(path) eq 0 then return

    xy2ad, reform(path[0,*]), reform(path[1,*]), src_ast, path_ra, path_dec
    ad2xy, path_ra, path_dec, dst_ast, path_x, path_y

    npath = n_elements(info)
    for i=0, npath-1 do begin
        p = info[i]
        x = path_x[p.offset + indgen(p.n)]+0.5
        y = path_y[p.offset + indgen(p.n)]+0.5

        if p.type eq 1 then begin
            x = [x, x[0]] & y = [y, y[0]]
        endif

        if keyword_set(filled) then begin
            polyfill, x, y, _extra=fill_extra
        endif

        oplot, x, y, _extra=extra
    endfor
end
