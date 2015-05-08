function tick_format, axis, set=set
    common tick_format_com, value
    if ~provided(value) then value = ['','','']
    if provided(set) then value[axis] = set
    return, value[axis]
end
