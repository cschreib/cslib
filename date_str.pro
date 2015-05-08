; Returns a string containing the current date in the 'ddmmyy' format
;
function date_str
    date = systime(/julian)
    caldat, date, mo, da, yr
    
    sda = strn(da, format='(I2)')
    if strlen(sda) eq 1 then sda = '0'+sda
    smo = strn(mo, format='(I2)')
    if strlen(smo) eq 1 then smo = '0'+smo
    syr = strn(yr mod 100, format='(I2)')
    if strlen(syr) eq 1 then syr = '0'+syr
    
    return, syr+smo+sda
end
