function getplotpos
    if !p.multi[1] gt 0 or !p.multi[2] gt 0 then return, cplotpos() else return, mplotpos(/current)
end

; Return the positions of a plot and its legend as should be used in the 'position' keyword.
;
; Keywords:
;  - top, bottom: specify where the legen should be located
;  - width: specify the width of the color bar in character size
;  - title: set this keyword if you want to add a title to the legend, so that some space is
;           reserved for it
;
function bake_legend, top=top, bottom=bottom, width=width, title=title
    if ~provided(width) then width = 1
    if keyword_set(title) then begin
        if keyword_set(bottom) then begin
            bmargin = 2
            tmargin = 0
        endif else begin
            bmargin = 0
            tmargin = 2
        endelse
    endif else begin
        tmargin = 0
        bmargin = 0
    endelse

    tppos = getplotpos()
    oy = !y
    !y.margin = [oy.margin[0]+bmargin, oy.margin[1]+tmargin]
    oppos = getplotpos()

    if keyword_set(bottom) then begin
        tppos = tppos[1]

        !y.margin = [oy.margin[0]+bmargin+4+width, oy.margin[1]+tmargin]
        mppos = getplotpos()
        mppos[0] = oppos[0] & mppos[2] = oppos[2]

        !y.margin = [oy.margin[0]+bmargin+width+tmargin, oy.margin[1]+tmargin]
        bppos = getplotpos()
        bppos[0] = oppos[0] & bppos[2] = oppos[2]
        bppos[3] = bppos[1] & bppos[1] = oppos[1]
    endif else begin
        tppos = tppos[3]

        !y.margin = [oy.margin[0]+bmargin, oy.margin[1]+width+tmargin]
        mppos = getplotpos()
        mppos[0] = oppos[0] & mppos[2] = oppos[2]

        bppos = mppos
        bppos[1] = mppos[3] & bppos[3] = oppos[3]
    endelse

    !y = oy

    return, {plot_pos:mppos, leg_pos:bppos, tit_pos:tppos}
end
