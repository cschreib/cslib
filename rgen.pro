; Generates an array containing linearly spaced values.
;
; Arguments:
;  - mi, ma: minimum and maximum values used to generate the array
;  - n: number of elements in the generated array
;
function rgen, mi, ma, n
    if ~provided(n) then n = ma - mi + 1
    return, (ma - mi)*findgen(n)/float(n-1) + mi
end
