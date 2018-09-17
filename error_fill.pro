; Fills the area between lower and upper error bars
;
; Arguments:
;  - x: x axis position
;  - yl, yu: the lower and upper error bars.
;
; Keywords:
;  - color: the color to use to fill the area (default: !p.color)
;  - spacing: if style is > 0, control the distance between strips
;  - style:
;     0: plain color (default)
;     1: +45° strips
;     2: -45° strips
;     3: horizontal strips
;
pro error_fill, x, yl, yu, color=color, style=style, spacing=spacing, bars=bars, bcolor=bcolor, $
    _extra=extra

    if ~provided(style) then style = 0

    case style of
    0: begin
        line_fill = 0
    end
    1: begin
        line_fill = 1
        orientation = 45.0
    end
    2: begin
        line_fill = 1
        orientation = -45.0
    end
    3: begin
        line_fill = 1
    end
    endcase

    tyu = yu > yl
    tyl = yu < yl

    good = finite(yl) and finite(yu) and finite(x)

    wasgood = 0
    lastgood = 0
    for i=0, n_elements(x)-1 do begin
        if good[i] ne wasgood then begin
            if good[i] then begin
                lastgood = i
            endif else begin
                j = lastgood
                tx = [reform(x[j:i-1]), reverse(reform(x[j:i-1]))]
                ty = [reform(tyu[j:i-1]), reverse(reform(tyl[j:i-1]))]

                polyfill, tx, ty, color=color, line_fill=line_fill, orientation=orientation, $
                    spacing=spacing, noclip=0
            endelse

            wasgood = good[i]
        endif
    endfor

    if wasgood then begin
        j = lastgood
        tx = [reform(x[j:*]), reverse(reform(x[j:*]))]
        ty = [reform(tyu[j:*]), reverse(reform(tyl[j:*]))]

        polyfill, tx, ty, color=color, line_fill=line_fill, orientation=orientation, $
            spacing=spacing, noclip=0
    endif

    if keyword_set(bars) then begin
        if ~provided(bcolor) and provided(color) then bcolor = color
        errplot, x, tyu, tyl, color=bcolor, _extra=extra
    endif
end
