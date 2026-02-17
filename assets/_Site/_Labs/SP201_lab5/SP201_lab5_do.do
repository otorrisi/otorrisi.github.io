******************
*** Lab 5 do file **
*****************

use "SP201_lab4.dta"


**** start by generating a basic contigency table
tabulate low_pay female if nomiss==1

*** However, we want to obtain column percentages to look at the percentage of men and women who are low paid
tabulate low_pay female if nomiss==1, column

** Now, want to compute chi-square test to see how likely the difference we see in our sample is due to chance alone. In other words, 
** how likely is it that this difference also exists in the population?
tabulate low_pay female if nomiss==1, column chi2

** Testing assumptions 
tabulate low_pay female if nomiss==1, column

**** Group work 1: Are the occupations of men and women different?

* generate descriptive table
tab occup female if nomiss==1, col

** now, with the chi-square test
tab occup female if nomiss==1, col chi2

** Testing assumptions 
tabulate occup female if nomiss==1, column


save "SP201_lab5.dta", replace
