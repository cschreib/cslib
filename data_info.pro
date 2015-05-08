; Print some information about the distribution of the provided data set
;
; Arguments:
;  - d: the data to analyse
;  - r: minimum and maximum values of the data to consider (used to filter out 'invalid' values
;       such as +-99 or -1)
;
pro data_info, d, range=range
    if provided(range) then begin
        ; Filter nan, infinite and out of range values
        ids = where(finite(d) and d ge range[0] and d le range[1], cnt)
    endif else begin
        ; Filter nan and infinite values
        ids = where(finite(d), cnt)
    endelse

    print, strn(cnt)+' valid values over '+strn(n_elements(d))
    if cnt eq 0 then return

    ids = ids[sort(d[ids])]
    ld  = d[ids]

    print,'min  : ',strn(min(ld))
    print,'16%  : ',strn(percentile(ld, 0.16))
    print,'32%  : ',strn(percentile(ld, 0.32))
    print,'med  : ',strn(median(ld))
    print,'mean : ',strn(mean(ld))
    print,'68%  : ',strn(percentile(ld, 0.68))
    print,'84%  : ',strn(percentile(ld, 0.84))
    print,'max  : ',strn(max(ld))
end
