function tick_expr, axis, index, x, set=set
    common tick_format_com, value
    if ~provided(value) then value = replicate('strn(x)', 3)
    if provided(set) then begin
        value[axis] = set
        return, 0
    endif

    void = execute('y = '+value[axis])
    return, y
end
