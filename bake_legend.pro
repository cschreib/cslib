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
function bake_legend, top=top, bottom=bottom, width=width, title=title, inset_legend=inset_legend
    if ~provided(width) then width = 1

    if keyword_set(title) then begin
        if keyword_set(bottom) then begin
            ttmargin = [2,0]
        endif else begin
            ttmargin = [0,2]
        endelse
    endif else begin
        ttmargin = [0,0]
    endelse

    ; Compute total legend bar width
    twidth = width
    if keyword_set(bottom) then twidth += 4
    tlmargin = [0,0]
    tlmargin[~keyword_set(bottom)] = twidth

    ; Store allocated plot area
    oy = !y

    ; Compute margins
    if keyword_set(inset_legend) then begin
        pmargin = !y.margin
        lmargin = !y.margin - tlmargin
        tmargin = !y.margin - tlmargin - ttmargin
    endif else begin
        pmargin = !y.margin + tlmargin + ttmargin
        lmargin = !y.margin + ttmargin
        tmargin = !y.margin
    endelse

    ; Get plot positions
    !y.margin = tmargin
    tpos = getplotpos()
    !y.margin = lmargin
    lpos = getplotpos()
    !y.margin = pmargin
    ppos = getplotpos()

    ; Get title position
    if keyword_set(bottom) then begin
        tppos = tpos[1]
    endif else begin
        tppos = tpos[3]
    endelse

    ; Get legend position
    bppos = lpos
    if keyword_set(bottom) then begin
        bppos[3] = ppos[1]
    endif else begin
        bppos[1] = ppos[3]
    endelse

    ; Get plot position
    mppos = ppos

    ; Restore plotting state
    !y = oy

    return, {plot_pos:mppos, leg_pos:bppos, tit_pos:tppos}
end
