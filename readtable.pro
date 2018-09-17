; Read the content of a text file containing data arranged in columns.
; Returned array is arranged as (number of columns, number of lines).
; It is an alternative to 'readcol' that supports many more columns to load. It is simpler though
; and may not be able to parse as many files as 'readcol' does.
;
; Arguments:
;  - file: the file to parse
;
; Keywords:
;  - numcol: the number of columns in the file (if not set, will be estimated from the first line
;            that is not skipped), overriden by 'names'
;  - as_string: if set, extract all the columns as strings, else extract data as double numbers. If
;               a value is not convertible to double, it will be set to !values.d_nan.
;  - skip: ammount of lines to skip at the beginning of the file (default: 0)
;  - names: names of each column that is read. If set, the output of this function is a structure
;           with tags named after these names, containing the associated column data. Setting this
;           keyword automatically enables the 'as_string' flag.
;  - types: type of each column that is read. Only used if 'names' is provided. See 'as_string' for
;           the default behavior. Accepted types: 'I' (fix), 'L' (long), 'F' (float), 'D' (double),
;           'S' (string), '' (default type). Note that if one wants to obtain string values ('S'),
;           one has to set the 'as_string' keyword (it will also be faster in any case).
;
function readtable, file, numcol=numcol, names=names, types=types, skip=skip, noautoskip=noautoskip, as_string=as_string
    openr, lun, file, /get_lun

    ; Skip lines starting with '#'
    if ~keyword_set(noautoskip) and n_elements(skip) eq 0 then begin
        skip = 0
        line = ''
        while ~eof(lun) do begin
            readf, lun, line
            if strpos(strtrim(line), '#') ne 0 then begin
                break
            endif
            ++skip
        endwhile

        point_lun, lun, 0
    endif

    ; Skip the first lines if asked
    if n_elements(skip) ne 0 then skip_lun, lun, skip, /lines

    ; Store the starting position
    point_lun, -lun, stpos

    ; Find the total number of line
    nline = 0L
    while ~eof(lun) do begin
        nline++
        skip_lun, lun, 1, /lines
    endwhile

    point_lun, lun, stpos

    ; Find the total number of collumn
    if n_elements(names) ne 0 then begin
        numcol = n_elements(names)
        if n_elements(as_string) eq 0 then as_string = 1
    endif

    if n_elements(numcol) eq 0 then begin
        line = ''
        while line eq '' and ~eof(lun) do begin
            point_lun, -lun, stpos
            readf, lun, line
        endwhile

        if eof(lun) then return, -1

        numcol = n_elements(strsplit(line))
        point_lun, lun, stpos
    endif

    ; Begin the extraction
    if keyword_set(as_string) then begin
        res = strarr(numcol, nline)
        line = ''
        for l=0L, nline-1L do begin
            readf, lun, line
            vals = strsplit(line, /extract)
            if n_elements(vals) lt numcol then vals = [vals, replicate('', numcol - n_elements(vals))]
            if n_elements(vals) gt numcol then vals = vals[lindgen(numcol)]
            res[*,l] = vals
        endfor
    endif else begin
        res = dblarr(numcol, nline)
        line = ''
        for l=0L, nline-1L do begin
            readf, lun, line
            vals = strsplit(line, /extract)
            if n_elements(vals) lt numcol then vals = [vals, replicate('0.0', numcol - n_elements(vals))]
            if n_elements(vals) gt numcol then vals = vals[lindgen(numcol)]

            valid = 0
            on_ioerror, bad_num
            res[*,l] = vals
            valid = 1
            bad_num: if ~valid then begin
                for i=0L, n_elements(vals)-1 do begin
                    on_ioerror, bad_num2
                    valid = 0
                    res[i,l] = vals[i]
                    valid = 1
                    bad_num2: if ~valid then res[i,l] = !values.d_nan
                endfor
            end
        endfor
    endelse

    free_lun, lun

    if n_elements(names) ne 0 then begin
        if n_elements(types) ne 0 then begin
            if n_elements(types) ne n_elements(names) then message, "error: 'names' and 'types' must have identical sizes"
            ntypes = types
            idi = where(types eq 'I', cnt) & if cnt ne 0 then ntypes[idi] = 'fix'
            idi = where(types eq 'L', cnt) & if cnt ne 0 then ntypes[idi] = 'long'
            idi = where(types eq 'F', cnt) & if cnt ne 0 then ntypes[idi] = 'float'
            idi = where(types eq 'D', cnt) & if cnt ne 0 then ntypes[idi] = 'double'
            idi = where(types eq 'S', cnt) & if cnt ne 0 then ntypes[idi] = 'string'
            idi = where(types eq '', cnt) & if cnt ne 0 then begin
                if keyword_set(as_string) then ntypes[idi] = 'string' else ntypes[idi] = 'double'
            endif

            vars = ntypes[0]+'(reform(res[0,*]))'
            if numcol gt 1 then vars += strjoin(', '+ntypes[lindgen(numcol-1)+1]+'(reform(res['+strna(lindgen(numcol-1)+1)+',*]))')
        endif else begin
            vars = 'reform(res[0,*])'
            if numcol gt 1 then vars += strjoin(', reform(res['+strna(lindgen(numcol-1)+1)+',*])')
        endelse
        void = execute('sres = create_struct(names, '+vars+')')
        return, sres
    endif else begin
        return, res
    endelse
end
