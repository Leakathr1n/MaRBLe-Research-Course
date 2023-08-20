*Exercise A.Height*
reg weight height
twoway (scatter weight height)

*Exercise B. Cognition and Wages*
tabstat cog_1, stats(mean sd skew) by(sex)
table sex, content(p10 cog_1 p50 cog_1 p90 cog_1)
histogram cog_1, by(sex) 

gen lnwage = log(wage)
reg cog_1 age sex lnwage
reg cog_2 age sex lnwage
reg cog_3 age sex lnwage
reg cog_4 age sex lnwage

*Exercise C. Body Mass Index*
generate heightm = height/100
generate heightmsqr= heightm*heightm
generate bmi= weight/heightmsqr
twoway (scatter weight height)
hist bmi
drop if bmi> 100
hist bmi

*To get proper code for sex*

g male = sex
replace male=1 if sex==1
replace male=0 if sex==2

bys year sex birth: egen m=mean(bmi)
graph bar (mean) bmi, over(birth) by(sex)

table sex, contents(mean bmi p10 bmi p50 bmi p90 bmi) 

generate birthmale = birth*male
generate educmale = educ*male
generate incmae = income*male

reg bmi birth educ income birthmale educmale incmale

reg bmi diet

