; Picks values randomly from the provided array.
;
; Arguments:
;  - data: the array from which to pick the values
;
; Keywords:
;  - num_ids: then number of values to pick (may not be greater than the total number of values)
;  - seed: the seed to use to generate the random values
;
function shuffle, data, num_ids=num_ids, seed=seed
    if ~provided(num_ids) then num_ids = n_elements(data)
    
    if provided(data) then begin
        ids = sort(randomu(seed, n_elements(data)))
        return, data[ids[lindgen(num_ids < n_elements(data))]]
    endif else begin
        ids = sort(randomu(seed, num_ids))
        return, ids
    endelse
end
