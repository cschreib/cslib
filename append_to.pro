; Append an element to an array.
; This procedure is mostly usefull when one needs to create an array of values without knowing at
; first how many values it will contain. A trivial example:
;    for i=0, 10 do begin
;        append, array, i, first=(i eq 0)
;    endfor
;
; It is the exact equivalent of:
;    for i=0, 10 do begin
;        if i eq 0 then array = i else array = [array, i]
;    endfor
;
; Arguments:
;  - data: the array to append to
;  - elem: the element to append
;
; Keyword:
;  - first: set this keyword when the array has not yet been created, i.e. when you want to append
;           the first element
;
pro append_to, data, elem, first=first
    if ~provided(first) then first = n_elements(data) eq 0
    if keyword_set(first) then data = elem else data = [data, elem]
end
