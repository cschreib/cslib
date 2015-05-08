function array_index2d, array, ids1, ids2
    sa = size(array)
    return, flatten(transpose(areplicate(ids1, n_elements(ids2))) + $
        areplicate(ids2, n_elements(ids1))*sa[1])
end
