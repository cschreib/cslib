function mad_clip, dat, sigma
    id = where(finite(dat))
    med = median(dat[id])
    mad = median(abs(dat[id] - med))
    return, abs(dat - med) lt sigma*mad
end
