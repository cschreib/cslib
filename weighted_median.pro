function weighted_median, x, w
    gid = where(finite(x) and (w eq w), cnt)
    if cnt eq 0 then return, !values.f_nan

    tx = x[gid] & tw = w[gid]
    sid = sort(tx)
    tx = tx[sid] & tw = tw[sid]

    nx = n_elements(tx)
    if nx eq 1 then return, tx[0]

    nid = nx/2
    tot = total(tw)

    if total(tw[0:nid]) gt tot/2.0 then begin
        if nid eq 0 then return, tx[0]
        nid--
        while total(tw[0:nid]) gt tot/2.0 and nid ne 0 do nid--
        nid++
    endif else begin
        while total(tw[0:nid]) le tot/2.0 and nid ne nx-1 do nid++
    endelse

    return, tx[nid]
end
