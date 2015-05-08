function strzerofill, v, n
    tmp = strn(v)
    tmp = strrepeat('0',long(alog10(n-1))+1 - strlen(tmp))+tmp
    return, tmp
end
