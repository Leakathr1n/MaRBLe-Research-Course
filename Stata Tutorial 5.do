clear
*set observations to 1000*
set obs 1000
*create new variables from normal distirbution*
drawnorm x e1
*check if normal*
hist x
hist e1
*generate dependent variable*
gen y =10+3*x+e1
*regression to check*
reg y x
*introduce new variables with measurement error*
drawnorm m1 m2
gen x1 = x+m1
gen x2 = x+m2
*regression with measurement error*
reg y x1
*cannot do the following in practise*
reg y x m1
*use x2 as IV*
reg y x2
reg x1 x2
*we need predications from last regression*
predict x1p
*calculate difference between true x and predicted x*
gen x1pr=x-x1p
reg y x1p x1pr m1
*second stage 2SLS --> IV variable*
reg y x1p

*could have only used these commands*
reg x1 x2
predict x1p 
reg y x1p

ivreg (x1=x2)

set seed 4

*Start 2nd task*


clear
set obs 1000 
*set up variables*
drawnorm e1 e2 e3 e4 
g z=10 + 2 * e2 
gen x2= 5 * e3 
g x1 = 12 + 3 * z + 5 * x2 + e4 
g y = 100 + 5 * x1 + 10 * x2 + e1 
*reg x1 and x2 --> includes almost true parameters*
reg y x1 x2
*gives incorrect results because of omitted variable buas*
reg y x1 
*split x1 in a comonent related to x2 and not*
gen x1_nx2= 12 + 3 * z + e4
gen x1_x2= 5 * x2 
*only a bias in component related to x2*
reg y x1_nx2 x1_x2
 
*create IV*
reg y z 
reg x1 z 
predict x1p 
gen x1pr=x1_nx2-x1p 
reg y x1p x1pr x1_x2 
reg y x1p
