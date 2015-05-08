; Clamp a value between a minimum and a maximum.
;
function clamp, val, mi, ma
    if ~provided(mi) then mi = 0.0
    if ~provided(ma) then ma = 1.0
    return, mi > val < ma
end

