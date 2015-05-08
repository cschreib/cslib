; Generate an interpolated rainbow of colors.
;
; Arguments:
;  - x: [optional] if not provided, this function simply returns 'rbow'. If it contains a single
;       value greater or equal to 1, generate 'x' regularly interpolated colors from the rainbow.
;       Else (can be an array of several real values), generate colors interpolated from the rainbow
;       (0.0: the first color, 1.0: the last color).
;
; Keywords:
;  - rbow: the rainbow to use. Defaults to the standard rainbow colors (red, yellow, green, cyan,
;          blue, magenta).
;
function color_rainbow, x, rbow=rbow, table=table
    if provided(rbow) then begin
        trbow = rbow
    endif else begin
        if ~provided(table) then table = 'rbow1'
        case table of
        'rbow1' : trbow = [color(255,0,0), color(255,255,0), color(0,255,0), color(0,255,255), color(0,0,255), color(255,0,255)]
        'rbow2' : trbow = [color(255,0,0), color(255,255,0), color(0,255,0), color(0,0,255)]
        'rbow3' : begin
            ; http://www.sron.nl/~pault/
            xx = indgen(254)/253.0
            bowred = round(255.*(0.472-0.567*xx+4.05*xx^2)/(1.+8.72*xx-19.17*xx^2+14.1*xx^3))
            bowgreen = round(255.*(0.108932-1.22635*xx+27.284*xx^2-98.577*xx^3+163.3*xx^4-131.395*xx^5+40.634*xx^6))
            bowblue = round(255./(1.97+3.54*xx-68.5*xx^2+243*xx^3-297*xx^4+125*xx^5))

            trbow = intarr(n_elements(bowred))
            for i=0, n_elements(bowred)-1 do trbow[i] = color(bowred[i], bowgreen[i], bowblue[i])
        end
        'rbow4' : trbow = [color(120,28,129),color(63,78,161),color(70,131,193),color(87,163,173),color(109,179,136),color(177,190,78),color(223,165,58),color(231,116,47),color(217,33,32)]
        'rbow5' : trbow = [color(120,28,129),color(63,78,161),color(70,131,193),color(87,163,173),color(109,179,136),color(177,190,78),color(223,165,58),color(231,116,47),color(217,33,32),color(255,255,255)]
        endcase
    endelse

    if n_params() eq 0 then return, trbow

    nstep = n_elements(trbow)

    if n_elements(x) eq 1 and x[0] ge 1 then tx = findgen(x[0])/(nstep-1.001) mod 1.0 else tx = clamp(x)

    low = floor(tx*(nstep-1))
    frac = tx*(nstep-1) - low

    colors = color_interpol(trbow[low], trbow[low+1], frac)

    return, colors
end
