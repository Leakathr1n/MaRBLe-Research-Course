*Import data*
use "C:\Users\Lea Röller\Downloads\Data_marble_2023.dta"

*inspect data*
browse
*we have panel data set, so we need to tell stata that we have a panel data with firmnr as unit and month as time variable*
xtset firmnr month 
*always get an error message, so we need to find the error*
*still does not work, maybe issue is that some months are used twice, so I need to create a new variable*
egen YM = group(year month)
browse
xtset firmnr YM
*get summary statistics to verify wether data is standardised and has appropriate values*
sum firmnr year month sectorid AI Envir CustSat lockdown bankrupt revenue 

*plot histogram to assess the issue of outliers*
hist bankrupt, title ("Density of Bankrupt")xtitle("Firm-specific Expectation to Go Bankrupt Within the Next Two Years")
keep if bankrupt > 5
browse

*repeat some steps to get old data set back*
clear 
use "C:\Users\Lea Röller\Downloads\Data_marble_2023.dta"
egen YM = group(year month)
xtset firmnr YM

*make a histogram to look at revenue distribution among the two different groups before and after the lockdown*
egen treatment = max(lockdown), by(firmnr)

twoway (histogram revenue if treatment==0, color(red) title(Revenue Pre-Lockdown) legend(label(1 "Sector Without Lockdown"))) (histogram revenue if treatment==1, bstyle(outline) legend(label(2 "Sector With Lockdown"))) if YM < 40
twoway (histogram revenue if treatment==0, color(red) title(Revenue Post-Lockdown) legend(label(1 "Sector Without Lockdown"))) (histogram revenue if treatment==1, bstyle(outline) legend(label(2 "Sector With Lockdown"))) if YM > 39
*****************************************************************************
**********************************DiD****************************************
*****************************************************************************

*first, we need to verify that observations have the same revenue trend before the treatment takes place!*
gen treattime = treatment*YM
egen Sector_With_Lockdown = mean(revenue / (treatment == 1)), by(YM)
egen Sector_Without_Lockdown = mean(revenue / (treatment == 0)), by(YM)
*look for a common trend graphically*
tsline Sector_With_Lockdown Sector_Without_Lockdown, title("Revenue")xline(40 44, lcolor(gray) lpattern(dash))legend(label(1 "Sector With Lockdown") label(2 "Sector Without Lockdown")) xtitle("Months Measured Since Start of Data Set") ytitle("Revenue measured in SD")

*look for a common trend mathematically*
gen postlockdown = 0
replace postlockdown = 1 if YM > 39
gen interaction = postlockdown*treatment
generate interaction_time = YM*treatment

*perform DiD*
*before putting in Environment, we need to create dummy*
gen low = 0
replace low = 1 if Envir < 2
gen high = 0 
replace high = 1 if Envir > 2


*run DiD regression by constantly adding control variables*
reg revenue postlockdown treatment interaction
outreg2 using regression_results.doc, replace
reg revenue postlockdown treatment interaction i.sectorid
outreg2 using regression_results.doc
reg revenue postlockdown treatment interaction i.sectorid AI
outreg2 using regression_results.doc
reg revenue postlockdown treatment interaction i.sectorid AI low high
outreg2 using regression_results.doc
reg revenue postlockdown treatment interaction i.sectorid AI low high CustSat
outreg2 using regression_results.doc
reg revenue postlockdown treatment interaction i.sectorid AI low high CustSat bankrupt
outreg2 using regression_results.doc 


*potentially perform an F-test after*
test postlockdown interaction

*second DiD and make time frame narrower because of the dip!*
reg revenue postlockdown treatment interaction if YM < 45
outreg2 using regression_results.doc, replace
reg revenue postlockdown treatment interaction i.sectorid AI low high CustSat bankrupt if YM < 45
outreg2 using regression_results.doc

*****************************************************************************
******************************Panel Methods**********************************
*****************************************************************************
*fixed effects:*
xtset firmnr YM
xtreg revenue lockdown, fe
outreg2 using regression_results.doc, replace
gen AIlockdown = AI*lockdown
gen Envirlockdown_low = low*lockdown
gen Envirlockdown_high = high*lockdown
gen sectorlockdown=sectorid*lockdown
xtreg revenue lockdown sectorid AIlockdown Envirlockdown_low Envirlockdown_high i.sectorlockdown CustSat bankrupt, fe
outreg2 using regression_results.doc

*random effects* 
xtreg revenue lockdown, re
outreg2 using regression_results.doc
xtreg revenue lockdown sectorid AI low high CustSat bankrupt, re
outreg2 using regression_results.doc


*perform Hausmann test*
xtreg revenue lockdown sectorid AIlockdown Envirlockdown_low Envirlockdown_high i.sectorlockdown CustSat bankrupt, fe
estimates store fixeff 
xtreg revenue lockdown sectorid AI low high CustSat bankrupt, re
estimates store raneff
hausman fixeff raneff
