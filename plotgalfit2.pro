pro plotgalfit2, out_file, badpix=badpix
    img   = mrdfits(out_file, 1, /silent)
    model = mrdfits(out_file, 2, /silent)
    resi  = mrdfits(out_file, 3, /silent)

    if provided(badpix) then begin
        bad = mrdfits(badpix, /silent)
    endif else begin
        bad = img*0
    endelse

    idok = where(bad eq 0)

    rms = stddev(resi[idok])
    ; ma = max(2*rms, min(6*rms, max(img)))
    ma = 3*rms
    pos = mplotpos(multi=[3,1])
    plot2d, img,              nlevel=200, range=[-2*rms, ma], pos=mplotpos(pos=0)
    plot2d, model,            nlevel=200, range=[-2*rms, ma], pos=mplotpos(pos=1)
    plot2d, resi*(bad eq 0),  nlevel=200, range=[-2*rms, ma], pos=mplotpos(pos=2)
end
