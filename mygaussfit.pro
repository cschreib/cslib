; Non linear fit using a gaussian function 'y  =  amp*exp((x-x0)^2/(2*sigma)^2)
; Note : uses mpfit internally
;
; Arguments:
;  - xdata, ydata: the data to fit
;
; Keywords:
;  - yerr: errors on the y data (if absent, 1 is assumed for all points)
;  - start_params: help the algorithm by providing rough guesses of the fit parameters (amplitude, 
;                  deviation, and center)
;  - amp: set this flag if the amplitude of the gaussian is known and fixed in 'start_params[0]'
;  - sigma: set this flag if the amplitude of the gaussian is known and fixed in 'start_params[1]'
;  - x0: set this flag if the center of the gaussian is known and fixed in 'start_params[2]'
;
function mygaussfit, xdata, ydata, yerr=yerr, start_params=start_params, amp=amp, x0=x0, sigma=sigma
    if ~provided(start_params) then start_params = [1.0,1.0,0.0]
    if ~provided(yerr) then yerr = replicate(1.0, n_elements(xdata))
    
    ; 3 free parameters
    if ~keyword_set(amp) and ~keyword_set(x0) and ~keyword_set(sigma) then begin
        best_fit = mpfitexpr('p[0]*exp(-(x-p[2])^2/(2.0*p[1]^2))', xdata, ydata, yerr, start_params, /quiet)
    endif
    ; Fixed amplitude
    if keyword_set(amp) and ~keyword_set(x0) and ~keyword_set(sigma) then begin
        best_fit_tmp = mpfitexpr(string(start_params[0])+'*exp(-(x-p[1])^2/(2.0*p[0]^2))', xdata, ydata, $
            yerr, [start_params[1], start_params[2]], /quiet)
        best_fit = [start_params[0], best_fit_tmp]
    endif
    ; Fixed x0
    if ~keyword_set(amp) and keyword_set(x0) and ~keyword_set(sigma) then begin
        best_fit_tmp = mpfitexpr('p[0]*exp(-(x-('+string(start_params[2])+'))^2/(2.0*p[1]^2))', xdata, ydata, $
            yerr, [start_params[0], start_params[1]], /quiet)
        best_fit = [best_fit_tmp, start_params[2]]
    endif
    ; Fixed sigma
    if ~keyword_set(amp) and ~keyword_set(x0) and keyword_set(sigma) then begin
        best_fit_tmp = mpfitexpr('p[0]*exp(-(x-p[1])^2/(2.0*('+string(start_params[1])+')^2))', xdata, ydata, $
            yerr, [start_params[0], start_params[2]], /quiet)
        best_fit = [best_fit_tmp[0], start_params[1], best_fit_tmp[1]]
    endif
    ; Fixed amplitude and x0
    if keyword_set(amp) and keyword_set(x0) and ~keyword_set(sigma) then begin
        best_fit_tmp = mpfitexpr(string(start_params[0])+'*exp(-(x-'+string(start_params[2])+')^2/(2.0*p[0]^2))', $
            xdata, ydata, yerr, [start_params[1]], /quiet)
        best_fit = [start_params[0], best_fit_tmp[0], start_params[2]]
    endif
    ; Fixed amplitude and sigma
    if keyword_set(amp) and ~keyword_set(x0) and keyword_set(sigma) then begin
        best_fit_tmp = mpfitexpr(string(start_params[0])+'*exp(-(x-p[1])^2/(2.0*('+string(start_params[1])+')^2))', $
            xdata, ydata, yerr, [start_params[2]], /quiet)
        best_fit = [start_params[0], start_params[1], best_fit_tmp[0]]
    endif
    ; Fixed x0 and sigma
    if ~keyword_set(amp) and keyword_set(x0) and keyword_set(sigma) then begin
        best_fit_tmp = mpfitexpr('p[0]*exp(-(x-('+string(start_params[2])+'))^2/(2.0*('+string(start_params[1])+')^2))', $
            xdata, ydata, yerr, [start_params[0]], /quiet)
        best_fit = [best_fit_tmp[0], start_params[1], start_params[2]]
    endif
    
    best_fit[1] = abs(best_fit[1])
    return, best_fit
end
