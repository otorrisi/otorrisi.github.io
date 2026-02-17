******************
*** Do file for Lab 4
*******************

use "SP201_labdata_3.dta"

***** Recode work hours variable
codebook d_jbhrs if d_jbhrs<0, t(20)
gen hours=d_jbhrs
recode hours (-1 -2 -8 -9=.)
lab var hours "Number of hours worked per week"
sum hours

mark good
markout good pay female occup hours pref_yn


sum pay female occup hours pref_yn

sum pay female occup hours pref_yn if good==1


**** Creating a sample variable
generate sample=0
replace sample=1 if female==1 & good==1
tabulate sample

save "SP201_lab4.dta"
