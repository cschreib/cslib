; Read a portion of a FITS file without loading the whole file in memory.
; For extracting many sub regions, like when doing stacking, it may be less efficient than loading
; the file all at once and extracting the sub regions in RAM. However, some files are too large to
; fit in the RAM in the first place, so it may be the only alternative.
;
; Arguments:
;  - fcb: the FITS control block, as obtained by calling FITS_OPEN
;  - start: an array of 2 elements containing the coordinates of the top-left pixel
;  - npix: an array of 2 elements containing the width and height of the extracted region
;
; Keywords:
;  - hdr: the header of the FITS file. If provided, the extracted data will be converted according
;         to the instructions present in the header. The conversion operation has been copied from
;         FITS_READ.
;  - read_hdr: set this flag to read the header from the fits file, so that the extracted data can
;              be converted according to the instructions of the header. Will do nothing if the 'hdr'
;              keyword is already set. Uses HEADFITS.
; 
function subfits, fcb, start, npix, hdr=hdr, read_hdr=read_hdr
    bytes_per_word = (abs(fcb.bitpix[0])/8)
    
    case fcb.bitpix[0] of
       8:   type = 1          ; Byte
      16:   type = 2          ; Integer*2
      32:   type = 3          ; Integer*4
     -32:   type = 4          ; Real*4
     -64:   type = 5          ; Real*8
    endcase
    
	sub = make_array(dim=[npix[0], npix[1]], type=type, /nozero)
    
    first = long64(start[0] +             (start[1]+lindgen(npix[1]))*fcb.axis[0])
    last  = long64(start[0] + npix[0]-1 + (start[1]+lindgen(npix[1]))*fcb.axis[0])
    
    start = fcb.start_data[0] + first*bytes_per_word
    dim   = last - first + 1
    
    for i=0, npix[1]-1 do begin
	    point_lun, fcb.unit, start[i]
	    data = make_array(dim=dim[i], type=type, /nozero)
        readu, fcb.unit, data
        sub[*,i] = data
    endfor
    
    if ~provided(hdr) and keyword_set(read_hdr) then begin
        point_lun, fcb.unit, fcb.start_header[0]
        hdr = headfits(fcb.unit, /silent)
    endif
    
    if provided(hdr) then begin
        bscale = sxpar(hdr, 'bscale')
        if bscale eq 0.0 then bscale = 1.0
        bzero  = sxpar(hdr, 'bzero')
        bitpix = sxpar(hdr, 'bitpix')
        
        if bitpix lt 32 then begin
            bscale = float(bscale)
            bzero  = float(bzero)
        endif
        
        if bscale ne 1.0 then sub *= bscale
        if bzero  ne 0.0 then sub += bzero
    endif
    
    return, sub
end

