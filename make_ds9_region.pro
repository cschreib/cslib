pro make_ds9_region, file, ra, dec, text=text, color=color, size=size
    openw, lun, /get_lun, file

    printf, lun, '# Region file format: DS9 version 4.1'
    printf, lun, 'global color=green dashlist=8 3 width=2 font="helvetica 10 normal roman"'+$
            'select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1'
    printf, lun, 'fk5'

    sex = radectosex(ra, dec)
    if provided(text) then begin
        txt = text
        if size(txt, /type) eq size(1, /type) and n_elements(txt) eq 1 then $
            txt = strna(indgen(n_elements(ra)))
        if n_elements(txt) eq 1 then txt = replicate(txt, n_elements(ra))
    endif else begin
        txt = replicate('', n_elements(ra))
    endelse

    if provided(color) then begin
        col = color
        if n_elements(col) eq 1 then col = replicate(col, n_elements(ra))
    endif else begin
        col = replicate('green', n_elements(ra))
    endelse

    if size(col, /type) ne size('', /type) then begin
        cols = ['white', 'black', 'blue', 'cyan', 'green', 'yellow', 'red', 'magenta']
        ncol = n_elements(cols)
        tcol = ((round(col) mod ncol) + ncol) mod ncol
        col = replicate('green', n_elements(ra))

        for c=0, ncol-1 do begin
            id = where(tcol eq c, cnt)
            if cnt ne 0 then col[id] = cols[c]
        endfor
    endif

    if provided(size) then begin
        siz = size
        if n_elements(siz) eq 1 then siz = replicate(siz, n_elements(ra))
    endif else begin
        siz = replicate('2', n_elements(ra))
    endelse

    for i=0, n_elements(ra)-1 do begin
        line = 'circle('+sex[i,0]+','+sex[i,1]+','+strn(siz[i])+'") # width=3 text={'+txt[i]+'} color='+col[i]
        printf, lun, line
    endfor

    close, lun
    free_lun, lun
end
