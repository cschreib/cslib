; Utility function to simplify usage of Postscript output
;
; Usage:
;    while psplot(file, dim, ...) do begin
;        ; Plot as many graphs as you want inside the EPS figure
;    endwhile
;
; When first entering the loop, the 'psplot' function sets up the PS output, then the content of the
; loop is executed once. On the second iteration, 'psplot' closes the PS output and returns 0, hence
; stops the loop. This little trick can however break if an error occurs within the loop: the device
; is then never closed, and the plot driver ('x', 'ps', ...) is not restored, which may break the
; rest of the code (or not).
;
; Note: calls to 'psplot' may not be nested !
;
; Arguments:
;  - file: sets the PS file in which to save the output
;  - dim: sets the dimension of the PS file ([x, y])
;
; Keywords:
;  - reset: in case an error occured and/or the device has not been closed, reset to defaul state
;  - hfont: set this keyword to use hardware fonts (uglier but allow more features)
;  - ttf: name of the TrueType Font (TTF) to use (must be registered inside IDL)
;
; Notes:
;   * How to register a new TrueType Font in IDL.
;     - Find the .ttf file of the font you want to use
;     - Copy that file in $IDL_DIR/resource/fonts/tt/
;     - Open $IDL_DIR/resource/fonts/tt/ttfont.map
;     - At the end of the file, add a new line containing (separated by spaces):
;       - The IDL name of the font, i.e. "Arial" or "Arial Bold".
;         This is the name you will use inside IDL to reference the font.
;       - The name of the .ttf file, i.e. "arial.ttf".
;       - The character size correction to apply (leave at 1.0 at first)
;       - The object size correction to apply (use unknown: leave to 1.0).
;     - Restart IDL.
;     Advice: to set the character size properly, start with 1.0, and if the characters appear too
;     small compared to other fonts, decrease this value to, say, 0.5, and try again until you reach
;     a satisfactory result. For example, I use 0.6 for the DejaVu font.
;
function psplot, file, dim, reset=reset, hfont=hfont, ttf=ttf
    common psplot_com, started, oldp, oldx, oldy
    if n_elements(started) eq 0 then started = 0

    if started eq 1 or keyword_set(reset) then begin
        device, /close
        set_plot, 'x'
        !p = oldp
        !x = oldx
        !y = oldy
        !p.background = 0
        !p.color = 'ffffff'x
        started = 0
        void = mplotpos()
    endif else begin
        set_plot, 'ps'

        if n_elements(ttf) eq 0 then begin
            fexist = 0
            defsysv, '!default_font', exists=fexist
            if fexist then begin
                ttf = !default_font
            endif else begin
                ttf = 'Helvetica'
            endelse
        endif

        if ~keyword_set(hfont) then font = ttf
        device, filename=file, /encapsulated, xsize=dim[0], ysize=dim[1], set_font=font, $
            /color, /decomposed, tt_font=~keyword_set(hfont), /isolatin1
        oldp = !p
        oldx = !x
        oldy = !y
        !p.background = 'ffffff'x
        !p.color = 0
        if ~keyword_set(hfont) then !p.font = 1
        started = 1
    endelse

    return, started
end
