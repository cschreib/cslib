; Generate an interpolated rainbow of colors.
;
; Arguments:
;  - x: [optional] if not provided, this function simply returns 'rbow'. If it contains a single
;       value greater or equal to 1, generate 'x' regularly interpolated colors from the rainbow.
;       Else (can be an array of several real values), generate colors interpolated from the rainbow
;       (0.0: the first color, 1.0: the last color).
;
; Keywords:
;  - rbow: the rainbow to use. Defaults to the standard rainbow colors (red, yellow, green, cyan,
;          blue, magenta).
;
function color_rainbow, x, rbow=rbow, table=table
    if provided(rbow) then begin
        trbow = rbow
    endif else begin
        if ~provided(table) then table = 'rbow1'
        case table of
        'rbow1' : trbow = [color(255,0,0),color(255,255,0),color(0,255,0),color(0,255,255),color(0,0,255),color(255,0,255)]
        'rbow2' : trbow = [color(255,0,0),color(255,255,0),color(0,255,0),color(0,0,255)]
        'rbow3' : begin
            ; http://www.sron.nl/~pault/
            xx = indgen(254)/253.0
            bowred = round(255.*(0.472-0.567*xx+4.05*xx^2)/(1.+8.72*xx-19.17*xx^2+14.1*xx^3))
            bowgreen = round(255.*(0.108932-1.22635*xx+27.284*xx^2-98.577*xx^3+163.3*xx^4-131.395*xx^5+40.634*xx^6))
            bowblue = round(255./(1.97+3.54*xx-68.5*xx^2+243*xx^3-297*xx^4+125*xx^5))

            trbow = intarr(n_elements(bowred))
            for i=0, n_elements(bowred)-1 do trbow[i] = color(bowred[i], bowgreen[i], bowblue[i])
        end
        'rbow4' : begin
            trbow = [color(120,28,129),color(63,78,161),color(70,131,193),color(87,163,173),$
            color(109,179,136),color(177,190,78),color(223,165,58),color(231,116,47),color(217,33,32)]
        end
        'rbow5' : begin
            trbow = [color(120,28,129),color(63,78,161),color(70,131,193),color(87,163,173),$
            color(109,179,136),color(177,190,78),color(223,165,58),color(231,116,47),color(217,33,32),$
            color(255,255,255)]
        end
        'viridis' : begin
            trbow = [color(68,1,84),color(68,2,86),color(69,4,87),color(69,5,89),color(70,7,90),$
            color(70,8,92),color(70,10,93),color(70,11,94),color(71,13,96),color(71,14,97),color(71,16,99),$
            color(71,17,100),color(71,19,101),color(72,20,103),color(72,22,104),color(72,23,105),$
            color(72,24,106),color(72,26,108),color(72,27,109),color(72,28,110),color(72,29,111),$
            color(72,31,112),color(72,32,113),color(72,33,115),color(72,35,116),color(72,36,117),$
            color(72,37,118),color(72,38,119),color(72,40,120),color(72,41,121),color(71,42,122),$
            color(71,44,122),color(71,45,123),color(71,46,124),color(71,47,125),color(70,48,126),$
            color(70,50,126),color(70,51,127),color(70,52,128),color(69,53,129),color(69,55,129),$
            color(69,56,130),color(68,57,131),color(68,58,131),color(68,59,132),color(67,61,132),$
            color(67,62,133),color(66,63,133),color(66,64,134),color(66,65,134),color(65,66,135),$
            color(65,68,135),color(64,69,136),color(64,70,136),color(63,71,136),color(63,72,137),$
            color(62,73,137),color(62,74,137),color(62,76,138),color(61,77,138),color(61,78,138),$
            color(60,79,138),color(60,80,139),color(59,81,139),color(59,82,139),color(58,83,139),$
            color(58,84,140),color(57,85,140),color(57,86,140),color(56,88,140),color(56,89,140),$
            color(55,90,140),color(55,91,141),color(54,92,141),color(54,93,141),color(53,94,141),$
            color(53,95,141),color(52,96,141),color(52,97,141),color(51,98,141),color(51,99,141),$
            color(50,100,142),color(50,101,142),color(49,102,142),color(49,103,142),color(49,104,142),$
            color(48,105,142),color(48,106,142),color(47,107,142),color(47,108,142),color(46,109,142),$
            color(46,110,142),color(46,111,142),color(45,112,142),color(45,113,142),color(44,113,142),$
            color(44,114,142),color(44,115,142),color(43,116,142),color(43,117,142),color(42,118,142),$
            color(42,119,142),color(42,120,142),color(41,121,142),color(41,122,142),color(41,123,142),$
            color(40,124,142),color(40,125,142),color(39,126,142),color(39,127,142),color(39,128,142),$
            color(38,129,142),color(38,130,142),color(38,130,142),color(37,131,142),color(37,132,142),$
            color(37,133,142),color(36,134,142),color(36,135,142),color(35,136,142),color(35,137,142),$
            color(35,138,141),color(34,139,141),color(34,140,141),color(34,141,141),color(33,142,141),$
            color(33,143,141),color(33,144,141),color(33,145,140),color(32,146,140),color(32,146,140),$
            color(32,147,140),color(31,148,140),color(31,149,139),color(31,150,139),color(31,151,139),$
            color(31,152,139),color(31,153,138),color(31,154,138),color(30,155,138),color(30,156,137),$
            color(30,157,137),color(31,158,137),color(31,159,136),color(31,160,136),color(31,161,136),$
            color(31,161,135),color(31,162,135),color(32,163,134),color(32,164,134),color(33,165,133),$
            color(33,166,133),color(34,167,133),color(34,168,132),color(35,169,131),color(36,170,131),$
            color(37,171,130),color(37,172,130),color(38,173,129),color(39,173,129),color(40,174,128),$
            color(41,175,127),color(42,176,127),color(44,177,126),color(45,178,125),color(46,179,124),$
            color(47,180,124),color(49,181,123),color(50,182,122),color(52,182,121),color(53,183,121),$
            color(55,184,120),color(56,185,119),color(58,186,118),color(59,187,117),color(61,188,116),$
            color(63,188,115),color(64,189,114),color(66,190,113),color(68,191,112),color(70,192,111),$
            color(72,193,110),color(74,193,109),color(76,194,108),color(78,195,107),color(80,196,106),$
            color(82,197,105),color(84,197,104),color(86,198,103),color(88,199,101),color(90,200,100),$
            color(92,200,99),color(94,201,98),color(96,202,96),color(99,203,95),color(101,203,94),$
            color(103,204,92),color(105,205,91),color(108,205,90),color(110,206,88),color(112,207,87),$
            color(115,208,86),color(117,208,84),color(119,209,83),color(122,209,81),color(124,210,80),$
            color(127,211,78),color(129,211,77),color(132,212,75),color(134,213,73),color(137,213,72),$
            color(139,214,70),color(142,214,69),color(144,215,67),color(147,215,65),color(149,216,64),$
            color(152,216,62),color(155,217,60),color(157,217,59),color(160,218,57),color(162,218,55),$
            color(165,219,54),color(168,219,52),color(170,220,50),color(173,220,48),color(176,221,47),$
            color(178,221,45),color(181,222,43),color(184,222,41),color(186,222,40),color(189,223,38),$
            color(192,223,37),color(194,223,35),color(197,224,33),color(200,224,32),color(202,225,31),$
            color(205,225,29),color(208,225,28),color(210,226,27),color(213,226,26),color(216,226,25),$
            color(218,227,25),color(221,227,24),color(223,227,24),color(226,228,24),color(229,228,25),$
            color(231,228,25),color(234,229,26),color(236,229,27),color(239,229,28),color(241,229,29),$
            color(244,230,30),color(246,230,32),color(248,230,33),color(251,231,35),color(253,231,37)]
        end
        endcase
    endelse

    if n_params() eq 0 then return, trbow

    nstep = n_elements(trbow)

    if n_elements(x) eq 1 and x[0] ge 1 then tx = findgen(x[0])/(nstep-1.001) mod 1.0 else tx = clamp(x)

    low = floor(tx*(nstep-1))
    frac = tx*(nstep-1) - low

    colors = color_interpol(trbow[low], trbow[low+1], frac)

    return, colors
end
