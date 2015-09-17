pro array_xy, a, x, y
    x = areplicate(indgen(n_elements(a[*,0])), n_elements(a[0,*]), /transpose)
    y = areplicate(indgen(n_elements(a[0,*])), n_elements(a[*,0]))
end
