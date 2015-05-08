; Compute the position of a plot on the device provided some parameters such as margins, multi plots...
;
; Keywords:
;  - multi: equivalent of !p.multi. Must be an array containing:
;           - the number of plots that remain to be displayed on the device
;           - the number of plots on the X axis
;           - the number of plots on the Y axis
;  - charsize: character size to use (default: !p.charsize or 1.0)
;  - [x/y]margin: margins to use for each individual plot. Can be either a scalar value or an
;                 array of two values to specify the [left,right] or [bottom,top] margins.
;                 Positive values mean that the plot will be smaller.
;  - o[x/y]margin: global margins to use for the whole set of multi plots, same as [x/y]margin
;
function cplotpos, multi=multi, charsize=charsize, xmargin=xmargin, ymargin=ymargin, oxmargin=oxmargin, oymargin=oymargin
    if ~provided(multi) then tmult = !p.multi else tmult = multi
    if ~provided(charsize) then charsize = !p.charsize
    if charsize eq 0.0 then charsize = 1.0
    if ~provided(xmargin) then xmargin = !x.margin
    if ~provided(ymargin) then ymargin = !y.margin
    if n_elements(xmargin) eq 1 then xmargin = [xmargin, xmargin]
    if n_elements(ymargin) eq 1 then ymargin = [ymargin, ymargin]
    if ~provided(oxmargin) then oxmargin = !x.omargin
    if ~provided(oymargin) then oymargin = !y.omargin
    if n_elements(oxmargin) eq 1 then oxmargin = [oxmargin, oxmargin]
    if n_elements(oymargin) eq 1 then oymargin = [oymargin, oymargin]

    ; Update !p.multi[0]
    if tmult[1] eq 0 then tmult[1] = 1
    if tmult[2] eq 0 then tmult[2] = 1
    if n_elements(tmult) ge 3 then if tmult[0] eq 0 then tmult[0] = tmult[1]*tmult[2]

    xch = !d.x_ch_size*charsize
    ych = !d.y_ch_size*charsize

    dx = (!d.x_size - (oxmargin[0]+oxmargin[1])*xch)/float(tmult[1])
    dy = (!d.y_size - (oymargin[0]+oymargin[1])*ych)/float(tmult[2])

    pp = tmult[1]*tmult[2] - tmult[0]
    xp = pp mod tmult[1]
    yp = pp /   tmult[1]

    xpos = (oxmargin[0]+xmargin[0])*xch + xp*dx              + [0, dx - (xmargin[0]+xmargin[1])*xch]
    ypos = (oymargin[0]+ymargin[0])*ych + (tmult[2]-yp-1)*dy + [0, dy - (ymargin[0]+ymargin[1])*ych]

    xpos /= !d.x_size
    ypos /= !d.y_size

    return, [xpos[0], ypos[0], xpos[1], ypos[1]]
end
