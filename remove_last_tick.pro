function remove_last_tick, axis, index, value
    if index eq tick_count(axis)-1 then return, ' ' else return, strn(value, format=tick_format(axis))
end
