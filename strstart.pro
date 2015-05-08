; Return 'true' if the provided string starts with a given pattern
function strstart, str, pattern
    if strlen(str) lt strlen(pattern) then return, byte(0)
    return, strmid(str, 0, strlen(pattern)) eq pattern
end
