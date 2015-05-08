function tick_count, axis, set=set
    common tick_count_com, value
    if ~provided(value) then value = [0,0,0]
    if provided(set) then value[axis] = set
    return, value[axis]
end
