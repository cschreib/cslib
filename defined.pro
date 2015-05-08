; Return 1 if the provided variable is defined, 0 else.
function defined, var
    return, n_elements(var) ne 0
end
