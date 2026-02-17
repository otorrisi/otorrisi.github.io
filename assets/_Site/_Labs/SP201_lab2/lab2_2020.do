****************************
** Lab 2 example do file ***
****************************

use "SP201_labdata_1.dta"

** Recoding gender 
codebook d_sex
gen female=d_sex

recode female (2=1) (1=0)
lab var female "Respondent is female"
lab def femalelbl 0 "Male" 1 "Female"
lab val female femalelbl
codebook female
tab female d_sex, missing 


** Recoding occupation
codebook d_jbnssec8_dv, t(20)
gen occup=d_jbnssec8_dv
recode occup (-9 -8=.)
lab var occup "Current job: Eight Class NS-SEC"
lab val occup d_jbnssec8_dv
codebook occup, t(20)
tab occup d_jbnssec8_dv, miss

** creating relative frequency table
tab occup

** creating a pie chart
graph pie, over(occup)

** creating a bar chart
graph bar, over(occup)


*** creating descriptive statistics for men and women separately
tab occup if female==0
tab occup if female==1
