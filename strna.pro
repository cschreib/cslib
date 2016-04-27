; Convert an array of anything into an array of strings.
; Wraps up the IDL Astron function 'strn', which saddly doesn't support arrays.
;
; Arguments:
;  - numbers: the variables that are to be converted into strings
;
; Keywords:
;  - + all keywords available to 'strn'
;
function strna, numbers, _extra=sextra
    if n_elements(numbers) eq 1 then return, strn(numbers, _extra=sextra)
    nn = n_elements(numbers)
    res = strarr(size(numbers, /dim))
    for i=0L, nn-1L do res[i] = strn(numbers[i], _extra=sextra)
    return, res
end
