pro xyouts_outline, x, y, txt, outline_thick=outline_thick, outline_col=outline_color, $
    outline_quality=outline_quality, color=color, _extra=extra

    if n_elements(outline_quality) eq 0 then outline_quality = 20
    if n_elements(outline_thick) eq 0 then outline_thick = 1
    if n_elements(color) eq 0 then color = !p.color
    if n_elements(outline_color) eq 0 then outline_color = color_invert(color)

    d = convert_coord([0,1,0], [0,0,1], /device, /to_data)
    ddx = reform(d[0,*])
    ddy = reform(d[1,*])

    dx = (ddx[1] - ddx[0])*!d.x_ch_size*0.2
    dy = (ddy[2] - ddy[0])*!d.x_ch_size*0.2

    for i=0, outline_quality-1 do begin
        xyouts, x+outline_thick*dx*cos(2*!dpi*i/float(outline_quality)), $
                y+outline_thick*dy*sin(2*!dpi*i/float(outline_quality)), $
                txt, color=outline_color, _extra=extra
    endfor

    xyouts, x, y, txt, color=color, _extra=extra
end
