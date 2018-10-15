function weighted_median, x, w
    gid = where(finite(x) and (w eq w), cnt)
    if cnt eq 0 then return, !values.f_nan

    tx = x[gid] & tw = w[gid]
    sid = sort(tx)
    tx = tx[sid] & tw = tw[sid]

    tcw = cumul(tw)
    tcw /= tcw[-1]

    return, tx[round(interpol(dindgen(cnt), tcw, 0.5))]
end
