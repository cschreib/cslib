; Shows the body of a procedure or a function
;
; Arguments:
;  - name: the name of the procedure or function that one seeks
;
pro showpro, name
    res = file_which(name+'.pro')
    if res eq '' then begin
        print, "unknown procedure '"+name+"'"
        return
    endif

    spawn, 'nl '+res[0]+' | more '
end
