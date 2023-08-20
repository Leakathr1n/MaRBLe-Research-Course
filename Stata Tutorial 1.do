*Exercise 2*
table sex
table country
table country, contents (mean wage)
table country, contents(mean wage p10 wage p50 wage p90 wage) 
tabulate country sex, row
tabulate country sex, col
*Exercise 3*
gen lnwage = ln(wage)
gen agesqr =age*age
*Exercise 4*
reg lnwage yos
reg lnwage yos sex age agesqr
reg lnwage yos sex age agesqr if country ==11 & sex ==0 & age > 35
xi: reg lnwage yos sex age agesqr i.country
