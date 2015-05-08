function mf_mint, m1, m2, mstar=mstar, phistar=phistar, index=index
    return, 10d0^mstar*phistar*gamma(index+2)*( $
        igamma(index+2, 10d0^(m2-mstar)) - igamma(index+2, 10d0^(m1 - mstar)))
end
