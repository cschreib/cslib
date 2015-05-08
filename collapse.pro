function collapse, array
    bt = flatten(byte(array))
    return, string(bt[where(bt ne 0)])
end
