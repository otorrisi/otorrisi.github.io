*****
** lab 8 regression diagnostics
*****



* run regression first
regress pay i.female i.pref2 wk_hrs i.occup if nomiss==1

** Looking for influential observations
avplot female, mlabel(pidp)


*** testing for linearity of residuals

* create residuals 
predict r, resid

* scatterplot of residual and DV with best fitting straight line (lfit) and smoothed line (lowess)
twoway (scatter r pay if nomiss==1) (lfit r pay if nomiss==1) (lowess r pay if nomiss==1)

******** Normality of residuals

kdensity r, normal


********* Homoscedasticity of residuals

* Breusch-Pagan test 
estat hettest

* plot of residuals versus fitted values
rvfplot, yline(0)


*** Multicollinearity

vif


**********
** With robust stadard errors
*****

regress pay i.female i.pref2 wk_hrs i.occup if nomiss==1, robust


***** 
** regression with logged variable

regress log_pay i.female i.pref2 wk_hrs i.occup if nomiss==1


* create residuals 
predict r2, resid

** Looking for influential observations
avplot female, mlabel(pidp)


*** testing for linearity of residuals

* scatterplot of residual and DV with best fitting straight line (lfit) and smoothed line (lowess)
twoway (scatter r2 pay if nomiss==1) (lfit r2 pay if nomiss==1) (lowess r2 pay if nomiss==1)

******** Normality of residuals

kdensity r2, normal


********* Homoscedasticity of residuals

* Breusch-Pagan test 
estat hettest

* plot of residuals versus fitted values
rvfplot, yline(0)


*** Multicollinearity

vif
