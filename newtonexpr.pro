function newtonexpr_fun, x
    common newtonexpr_com, cexpr, p
    void = execute('res = '+cexpr) 
    return, res
end

; Wrapper around IDL's 'newton' function that finds the zero of a function.
; This version works with an expression instead of a user defined function.
;
; Arguments:
;  - x0: an initial guess at the solution (or solutions if there are several variables)
;  - expr: a string that contains the expression to minimize. It must only reference the variables
;          'x[i]' where 'i' is the index of the variable in 'x0'. Additionally, the expression may
;          reference 'p[j]' where 'j' is an index of the keyword 'params' (if provided).
;
; Keywords:
;  - params: additional parameters to forward to the expression (accessed as 'p').
;
function newtonexpr, x, expr, params=params, _extra=nextra
    common newtonexpr_com, cexpr, p
    
    cexpr = expr
    if provided(params) then p = params
    return, newton(x, 'newtonexpr_fun', _extra=nextra)
end
