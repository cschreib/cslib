; Decompose an integer 'n' as a product of two other integers that are as similar as possible.
; The product of the two other integers can be larger than 'n' by at most 'result[0]-1'.
; This function can be used to place multiple plots on the same page: if one wants to draw 'n' plots
; then one can draw 'result[0]' graphics horizontally and 'result[1]' graphics vertically.
;
; Argument:
;  - n: the integer the decompose
; 
function squarize, n
    return, [ceil(sqrt(n)), ceil(n/float(ceil(sqrt(n))))]
end
