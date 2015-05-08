function nmad, x
    return, median(abs(x/median(x) - 1.0))
end
