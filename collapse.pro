function collapse, array, separator=separator
    tarray = array
    if n_elements(separator) ne 0 then begin
        s = replicate(separator, n_elements(array))
        s[n_elements(array)-1] = ''
        tarray += s
    endif

    bt = flatten(byte(tarray))
    return, string(bt[where(bt ne 0)])
end
