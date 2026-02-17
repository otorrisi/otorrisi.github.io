****** Creating table of descriptive statistics

sum pay if nomiss==1 & female==0, det
sum pay if nomiss==1 & female==1, det
sum pay if nomiss==1, det

sum hours if nomiss==1 & female==0, det
sum hours if nomiss==1 & female==1, det
sum hours if nomiss==1, det

tab occup female if nomiss==1, col 

tab pref_yn female if nomiss==1, col 

**** Scatterplot between variables
scatter pay hours if nomiss==1

** scatterplot with line of best fit
scatter pay hours if nomiss==1 || lfit pay hours if nomiss==1

*** Pearson's correlation coefficient
pwcorr pay hours if nomiss==1, sig

** spearman's rho

spearman pay hours if nomiss==1

** create log-transformed variable
generate log_pay=log(pay)

* compare the histograms
hist pay if nomiss==1
hist log_pay if nomiss==1

* Pearson's correlation coefficient

pwcorr log_pay hours if nomiss==1, sig

** spearman's rho

spearman log_pay hours if nomiss==1
