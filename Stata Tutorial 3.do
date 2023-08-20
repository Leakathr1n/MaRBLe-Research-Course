use "C:\Users\Lea Röller\Downloads\shop.dta"
hist score if year==2003 & sex==0
hist score if year==2005 & sex==0
hist score if year==2003 & sex==1
hist score if year==2005 & sex==1
reg score course if year==2005
outreg2 using results, word
outreg2 using results, word replace
reg score course sk
outreg2 using results, word
reg score course sk cr
outreg2 using results, word
reg score course sk cr di
outreg2 using results, word
reg score course sk cr di sc
outreg2 using results, word
reg score course sk cr di sc sex
outreg2 using results, word
reg score course sk cr di sc sex age
outreg2 using results, word
reg score course sk cr di sc sex age educ
outreg2 using results, word

*DiD analysis*
tabulate year course, summ(score)
gen treat = course
sort id year
replace treat = 1 if (id[_n]==id[_n+1] & treat[_n+1]==1)
tabulate year treat, summ(score)

*Get SE*
generate yeardummy = 1 if year==2003
replace yeardummy = 1
replace yeardummy = 0 if year==2003
gen DiDcoef = treat*yeardummy

reg score treat yeardummy DiDcoef
outreg2 using results, word replace
outreg2 using results, word
