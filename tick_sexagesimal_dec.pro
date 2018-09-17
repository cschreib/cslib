function tick_sexagesimal_dec, axis, index, value
    t = radectosex(0, value)
    return, trim_zero(t[1])
end
