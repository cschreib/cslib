; Replicate a string and store the result into a single string
;
; Arguments:
;  - str: the string to replicate
;  - cnt: the number of copies to create
;
function strrepeat, str, cnt
    if cnt ne 0 then begin
        return, string(replicate(str, cnt), format='('+strn(cnt)+'A)')
    endif else begin
        return, ''
    endelse
end
