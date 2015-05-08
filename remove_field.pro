; Remove some fields from a structure.
;
; Arguments:
;  - struct: the structure from which to remove the fields
;  - tags: the fields name to remove
;
function remove_field, struct, tags
    searchtag = strupcase(tags)
    tagnames = tag_names(struct)
    
    kids = find_non_matches(tagnames, searchtag, cnt)
    if cnt eq 0 then message, 'error: cannot remove all the fields from a structure'
    if cnt eq n_elements(tagnames) then return, struct
    
    newstruct = create_struct(tagnames[kids[0]], struct.(kids[0]))
    for i=1, cnt-1 do begin
        newstruct = create_struct(newstruct, tagnames[kids[i]], struct.(kids[i]))
    endfor
    
    return, newstruct
end
