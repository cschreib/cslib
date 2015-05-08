; Utility procedure that estimates the time remaning to complete all the iterations (the number of
; iteration thus has to be known beforehand).
; Usage:
;    estime, /start, num_iter=1000
;    for i=1, 1000 do begin
;        ; ...
;        estime, /iterate
;    endfor
;
; Keywords:
;  - start: set this keyword before the loops, to initialize the estimation procedure
;  - num_iter: the total number of iteration that are going to be performed
;  - print_rate: the rate at which to print the estimation (interpration of this value depends on
;    'rate_sec')
;  - rate_set: if not set, the print rate will be interpreted as a percentage of the number of
;              iteration: the estimation will be printed every 'print_rate*num_iter' iteration. If
;              set, the print rate will be interpreted as a duration in seconds: the estimation will
;              be printed every 'print_rate' seconds. 
;  - iterate: set this keyword at each iteration of the loop
;
pro estime, start=start, iterate=iterate, num_iter=num_iter, print_rate=print_rate, rate_sec=rate_sec
    common estime_common, start_time, iter, niter, rate, rsec, last_print, buffer, buffer_iter, buffer_ids, max_buffer, last_time

    if keyword_set(start) then begin
        start_time = systime(1)
        last_time = start_time
        
        iter = 0L
        niter = num_iter
        max_buffer = 100L
        buffer = dblarr(max_buffer)
        buffer_ids = lonarr(max_buffer) - 1
        buffer_iter = 0
        
        if ~provided(rate_sec) then rate_sec = 0
        rsec = rate_sec
        
        if ~keyword_set(rsec) then begin
            if ~provided(print_rate) then print_rate = 0.1
            rate = long(floor(num_iter*print_rate))
        endif else begin
            if ~provided(print_rate) then print_rate = 1
            rate = print_rate
            last_print = -1
        endelse
    endif else begin
        if keyword_set(iterate) then begin
            buffer_ids[buffer_iter] = iter
            current_time = systime(1)
            buffer[buffer_iter] = current_time - last_time
            ++buffer_iter
            if buffer_iter eq max_buffer then buffer_iter = 0
            last_time = current_time
        
            do_print = 0
            if ~keyword_set(rsec) then begin
                do_print = (iter mod rate) eq 0
            endif else begin
                if last_print lt 0 then begin
                    last_print = current_time
                    do_print = 1
                endif else begin
                    if current_time - last_print gt rate then begin
                        last_print = current_time
                        do_print = 1
                    endif 
                endelse
            endelse
            
            if iter eq niter-1 then do_print = 1
            
            if do_print then begin
                if iter eq 0 then begin
                    prevision = -1.0
                    elapsed = 0.0
                endif else begin
                    elapsed = systime(1) - start_time
                    samp = max([min([max_buffer, iter/2+1]), iter])
                    ids = iter - 1 - lindgen(samp)
                    idc = find_matches(ids, buffer_ids)
                    avgt = mean(buffer[idc.ids2])
                    prevision = elapsed + avgt*(niter - iter)
                endelse
                
                if niter gt 1 then begin
                    progress = floor(100.0*iter/float(niter-1))
                    ilength = floor(alog10(niter-1))+1
                endif else begin
                    progress = 100.0
                    ilength = 1
                endelse
                
                print, "Progress : ", strn(progress, format='(I3)'),"%", $
                       ". Iteration : ", strn(iter, format='(I'+strn(ilength)+')'), $
                       "/", strn(niter-1, format='(I'+strn(ilength)+')'), $
                       ". Elapsed time : ", timing_fmt(elapsed), $
                       ", remaining : ", timing_fmt(prevision - elapsed), $
                       ", total : ", timing_fmt(prevision)
            endif
            
            ++iter
        endif
    endelse
end
