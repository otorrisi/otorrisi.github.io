******************
*** Do file for Lab 3
*******************

use "SP201_labdata_2.dta"

** create table of descriptive statistics
* overall sample
summarize pay, detail 
* among women
summarize pay if female==1, detail
* among men
summarize pay if female==0, detail

**************
*** Graphs for the whole sample
****************

histogram pay, frequency
graph box pay

**************
*** Graphs for men and women separately
****************

histogram pay, frequency by(female)
graph box pay, by(female)

save "SP201_labdata_3.dta", replace


*******
