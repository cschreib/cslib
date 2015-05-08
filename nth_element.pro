; Return the n'th element of the provided data set when sorted
;
; Arguments:
;  - data: data to analyse
;  - n: position of the element in the sorted data set
;
; Keywords:
;  - sorted_id: set this keyword to an array containing sorted indices into 'data'
;               For successive calls to this function, it is better to provide this for performance.
;
function nth_element, data, n, sorted_id=sorted_id
    if ~provided(sorted_id) then sorted_id = sort(data)
    return, data[sorted_id[n]]
end
