; Check if a given structure contains a field whose name is 'field'.
;
function has_field, str, field
    return, total(strcmp(tag_names(str), field, /fold_case)) gt 0
end
