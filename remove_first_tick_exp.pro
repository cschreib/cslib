function remove_first_tick_exp, axis, index, value
    if index eq 0 then return, ' '
    if value eq 0 then return, '0'

    ; Assuming multiples of 10 with format.
    ex = strn(value, format='(e8.0)')
    pt = strpos(ex, '.')

    first = strmid(ex, 0, pt)
    sign = strmid(ex, pt+2, 1)
    expo = strmid(ex, pt+3)

    ; Shave off leading zero in exponent
    while strmid(expo, 0, 1) eq '0' do begin
        expo = strmid(expo, 1)
    endwhile

    ; Fix for sign and missing zero problem.
    if (long(expo) eq 0) then begin
        sign = ''
        expo = '0'
    endif

    ; Make the exponent a superscript.
    if float(first) eq 1.0 then beg = '10' else beg = first+'x10'

    if sign eq '-' then begin
        return, beg+'!U' + sign + expo + '!N'
    endif else begin
        return, beg+'!U' + expo + '!N'
    endelse
end
