use "C:\Users\Lea Röller\Downloads\retire.dta
gen day = day(birth)
gen month = month(birth)
gen year = year(birth)
gen diff=(mdy(month(birth),day(birth),year(birth)+65)-retire)/365.25 
sum diff
reg diff lives

*createtreatment variable for people that were born at 1 may 1932* 
gen treat = 0
replace treat = 1 if year(birth) > 1932 | (year(birth) == 1932 & mofd(birth) > mofd(date("01-05-1932", "DMY")))

reg live treat 
reg treat lives

*gen age-variables*
gen age1=(mdy(5,1,1932)-birth)/365.25 
gen age2=age1*age1 
gen age3=age2*age1 
gen age4=age3*age1 
gen age5=age4*age1 

reg lives treat age1 age2 age3 age4 age5

*look at treatment variable and lives by age*
gen y=year(birth) 
gen m=month(birth) 
gen b=day(birth) 
gen lives2=lives-.65 
graph bar (mean) diff, over(y) 
graph bar (mean) lives2, over(y)

*make a graph*
gen mm=(y-1930)*12+m 
graph bar (mean) diff if (y==1931 |y==1932 | y==1933), over(mm) 
graph bar (mean) lives2 if (y==1931 |y==1932 | y==1933), over(mm) 
*The next graphs further limit the window to 30 days before and after 1 May 1932:* 
graph bar (mean) diff if (birth>=mdy(5,1,1932)-30 & birth<=mdy(5,1,1932)+30), over(birth) 
graph bar (mean) lives2 if (birth>=mdy(5,1,1932)-30 & birth<=mdy(5,1,1932)+30), over(birth) 

reg lives treat if (birth>=mdy(5,1,1932)-1 & birth<mdy (5,1,1932)+1)
reg lives treat if (birth>=mdy(5,1,1932)-3 & birth<mdy (5,1,1932)+3)
reg lives treat if (birth>=mdy(5,1,1932)-5 & birth<mdy (5,1,1932)+5)
