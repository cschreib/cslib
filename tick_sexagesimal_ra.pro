function tick_sexagesimal_ra, axis, index, value
    t = radectosex(value, 0)
    return, trim_zero(t[0])
end
