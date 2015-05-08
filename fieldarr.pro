function fieldarr, struct, fields
    nfield = n_elements(fields)
    s = n_elements(struct.(fields[0]))
    data = replicate((struct.(fields[0]))[0], nfield, s)
    data[0,*] = struct.(fields[0])
    for i=1, nfield-1 do begin
        ts = n_elements(struct.(fields[i]))
        if ts ne s then message, 'error: cannot create array from structure, fields do not have the same dimension'
        data[i,*] = struct.(fields[i])
    endfor
    
    return, data
end
