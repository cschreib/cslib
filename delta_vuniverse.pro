function delta_vuniverse, z1, z2, _extra=extra
    return, vuniverse(z2, _extra=extra) - vuniverse(z1, _extra=extra)
end
