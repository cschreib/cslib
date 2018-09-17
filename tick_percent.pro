function tick_percent, axis, index, value
    return, strn(round(value), format='(I12)')+'%'
end
