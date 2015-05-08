function trim_zero, axis, index, value
    if value eq 0 then return, '0'
    str = byte(strn(value))
    i = strlen(str)-1
    while i gt 0 and str[i] eq byte('0') do i--
    if str[i] eq byte('.') then i--

    return, strmid(string(str), 0, i+1)
end
