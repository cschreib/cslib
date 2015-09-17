pro plot_map_pos, ra, dec, dst_ast, cdata=cdata, _extra=extra
    ad2xy, ra, dec, dst_ast, x, y

    if provided(cdata) then begin
        ocolplot, x+0.5, y+0.5, cdata, _extra=extra
    endif else begin
        oplot, x+0.5, y+0.5, _extra=extra
    endelse
end
