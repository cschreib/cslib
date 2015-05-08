; Helper function for 'limfitexpr', see below.
;
function limfitexpr_func, p, x=x, y=y, err=err, lim=lim, cntd=cntd, cntu=cntu, cntl=cntl, $
    idd=idd, idu=idu, idl=idl, model=model, _extra=private

    void = execute('ym = '+model)

    res = y*0d
    if cntd ne 0 then res[idd] = (y[idd]-ym[idd])/err[idd]
    if cntu ne 0 then res[idu] = sqrt(limweight((y[idu]-ym[idu])/err[idu]))
    if cntl ne 0 then res[idl] = sqrt(limweight((ym[idl]-y[idl])/err[idl]))

    return, res
end

; Perform a fit on the provided data set, where each "measurement" is either a detection or a limit
; (lower or upper). The weight of a limit measurement is given by 'limweight', see the documentation
; of this function for more information.
; This function is used just like C. Markwardt's 'mpfitexpr', except is has an additional argument.
;
; Arguments:
;  - model: the IDL expression that will fit the data. Same restrictions and features as for
;    'mpfitexpr': the expression must be a string of the form:
;        'p[0] + p[1]*x'
;    The names of the variables are imposed: 'x' holds the position at which to compute the model
;    (see the 'x' argument below), and 'p' holds the current values of the fitted parameters. The
;    expression must yield the modelled value of 'y' for this given parameter set. If you need to
;    provide additional data and variables, you can store them in 'functargs' and they will be
;    available as fields of the 'private' structure (see 'mpfitexpr' documentation).
;  - x: table containing the positions at which the model and the measurements are to be compared.
;  - y: table containing the measurements (either detections or limits).
;  - err: table containing the 1-sigma errors on the measurements (or the error on the limits).
;  - lim: table containing either 0 for measurements, 1 for upper limits and -1 for lower limits.
;  - start_params: table containing the start values of each fitted parameters (mandatory!)
;
; Keywords:
;  - + any keyword available to 'mpfit'.
;
; How and when to use upper limits:
; The analysed source has been observed with an instrument, and the flux extraction procedure
; produced a flux F and an error E on this flux. If the uncertainty on the measurement is really
; gaussian with no systematic (to be tested with MC simulation with fake sources, then by analysing
; the distribution of the extracted fluxes around the true value), then one should use the
; extracted flux regardless on the signal to noise. Basically, saying that a source has a flux of
; 1 mJy +/- 2 mJy (i.e. SNR = 0.5) provides more constraints than saying that is has an upper limit
; of 6 mJy (3 sigma). Upper limits can still be used in this case, but they give less information
; to the fitting procedure, and the best-fit will be more uncertain.
; On the other hand, if the error distribution is NOT gaussian (typically because of confusion
; noise, neighbor contamination or any other source of noise that may bias the result), it is safer
; not to use any flux measurement below a given threshold L (to be determined from the MC
; simulation). In this case, L should be considered as an upper limit, and the uncertainty on the
; measurement E fed as the "error" on the limit (actually this is the error on the fact that the
; flux is indeed below this limit, assuming gausssian statistics).
function limfitexpr, model, x, y, err, lim, start_params, functargs=functargs, _extra=fextra
    if n_elements(ye)  eq 1 then ye  = replicate(ye,  n_elements(x))
    if n_elements(lim) eq 1 then lim = replicate(lim, n_elements(x))

    idd = where(lim eq  0, cntd)
    idu = where(lim eq +1, cntu)
    idl = where(lim eq -1, cntl)

    args = {x:x, y:y, err:err, lim:lim, cntd:cntd, cntu:cntu, cntl:cntl, $
        idd:idd, idu:idu, idl:idl, model:model}

    if n_elements(functargs) ne 0 then args = create_struct(args, functargs)

    return, mpfit('limfitexpr_func', start_params, functargs=args, _extra=fextra)
end

