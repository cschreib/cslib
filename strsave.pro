; Save a set of variables inside a structure to prevent conflict when loading them back.
;
; Usage:
;  ; Saving the data
;  a = fltarr(10)
;  b = 'hello'
;  c = 5
;  strsave, 'file.save', 'str', a, b, c
;
;  ; Loading them back
;  restore, 'file.save'
;  print, str.a, str.b, str.c
;
; Arguments:
;  - filename: the name of the file into which the data will be saved
;  - strname: the name of the structure that will contain the data
;  - v0 ... v59: variables to save (up to 60 at the same time)
;
pro strsave, filename, strname, $ 
             v0,  v1,  v2,  v3,  v4,  v5,  v6,  v7,  v8,  v9, $
             v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, $
             v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, $
             v30, v31, v32, v33, v34, v35, v36, v37, v38, v39, $
             v40, v41, v42, v43, v44, v45, v46, v47, v48, v49, $
             v50, v51, v52, v53, v54, v55, v56, v57, v58, v59

    str = strname + ' = {'
    for i=2, n_params()-1 do begin
        if i ne 2 then str = str + ','
        void = execute('varname = scope_varname(v'+strn(i-2)+', level=-100)')
        str = str + varname[0] + ':v'+strn(i-2)
    endfor
    str = str + '}'
    void = execute(str)
    void = execute('save, filename=filename, '+strname)
end
