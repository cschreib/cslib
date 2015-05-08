function remove_first_tick, axis, index, value
    if index eq 0 then return, ' ' else return, strn(value, format=tick_format(axis))
end
