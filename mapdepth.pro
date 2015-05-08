pro mapdepth, file, fcor
    seed = 42

    img = readfits(file+'_sci.fits')
    cov = readfits(file+'_cov.fits')
    
    ; Define the minimum coverage as a fraction of the optimal coverage
    tmp = size(cov)
    numsample = 20
    optcov = fltarr(numsample)
    for i=0, numsample-1 do optcov[i] = cov[tmp[1]/2 + 10*randomu(seed), tmp[2]/2 + 10*randomu(seed)]
    
    mincov = 0.15*median(optcov)
    id = where(cov gt mincov and finite(img), ncov)
   
    ;bg = median(img[id])
    ;img = img - bg
    sid = sort(img[id])
    sid = id[sid]
    histplot_makebins, img[id], xdata, ydata, /continuous, numbins=200, xmax=img[sid[ncov*0.7]]
    void = max(ydata, idbg)
    bg = xdata[idbg]
    img = img - bg
    rmsf = sqrt(mean(img[id]^2))
    
    histplot_makebins, img[id], xdata0, ydata0, /continuous, numbins=200, xmax=img[sid[ncov*0.7]]
    symmetrize, xdata0, ydata0, xdata, ydata
    
    res = mpfitexpr('exp(-x^2/(2*p[0]^2))', xdata, ydata/max(ydata), 1.0/sqrt(ydata), rmsf, /quiet)
    res[0] = abs(res[0])
    print, 'Depth: ', res[0]*fcor
    
    histplot, img[id], numbins=200, xr=[-9*res[0], 9*res[0]], /ylog, ydata=ydata
    
    x = rgen(-5*res[0], 5*res[0], 100)
    oplot, x, max(ydata)*exp(-(x/(sqrt(2.0)*res[0]))^2), col='ff'x
end
