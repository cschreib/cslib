; Perform a simple trapezoidal integration, no weird behavior like IDL's int_tabulated.
function myint_tabulated, x, y
    n = n_elements(x)-1
    return, total((x[1:n] - x[0:n-1])*0.5*(y[1:n] + y[0:n-1]))
end
