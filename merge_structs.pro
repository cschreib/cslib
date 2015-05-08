function merge_structs, str1, str2
    n1 = tag_names(str1)
    n2 = tag_names(str2)

    kids = find_matches(n1, n2, cnt)
    if cnt eq 0 then return, create_struct(str1, str2)
    if cnt eq n_elements(n2) then return, str1
    if cnt eq n_elements(n1) then return, str2

    tmp = remove_field(str2, n2[kids.ids2])
    return, create_struct(str1, tmp)
end
