pro warning, msg, silent=silent
    print, '-------------------------------------------------'
    print, '                     WARNING'
    print, '-------------------------------------------------'
    print, '> ', msg
    if ~keyword_set(silent) then begin
        print, 'Continue ?'
        stop
    endif
end
