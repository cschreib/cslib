function error_ul, data
    med = median(data)
    up = percentile(data, 0.84)
    lo = percentile(data, 0.16)
    return, [med - lo, up - med]
end
