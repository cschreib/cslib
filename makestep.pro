; Convert a continuous curve to a histogram-like curve
;
; Arguments:
;  - xin, yin: the continuous curve
;
; Keywords:
;  - xdata, ydata: [output] the histogram-like conversion
;
pro makestep, xin, yin, xdata=xdata, ydata=ydata
    xdata = binify(xin, /interp)
    ydata = binify(yin)
    
    xdata = [xdata[0], xdata, xdata[n_elements(xdata)-1]]
    ydata = [0.0, ydata, 0.0]
end 
