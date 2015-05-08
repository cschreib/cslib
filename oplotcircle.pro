; Draw a circle on the current plot
;
; Arguments:
;  - center: coordinates (in data units) of the center of the circle
;  - radius: the radius of the circle (in data units)
;
; Keywords:
;  - npts: the number of points to use to generate the circle (default: 100)
;  - + all the keywords available to oplot
;
pro oplotcircle, center, radius, npts=npts, _extra=ex
    if ~keyword_set(npts) then npts = 100
    angdata = 2.0*!dpi*findgen(npts)/float(npts-1)
    xdata = radius*cos(angdata) + center[0]
    ydata = radius*sin(angdata) + center[1]
    oplot, xdata, ydata, _extra=ex
end

