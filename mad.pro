function mad, x
    return, median(abs(x - median(x)))
end
