****************************
** Lab 1 example do file ***
****************************

use "SP201_labdata_2020.dta"


* create pay variable
codebook d_paygu_dv

tabulate d_paygu_dv if d_paygu_dv<0

generate pay=d_paygu_dv
recode pay (-8 -7=.)
codebook d_paygu_dv pay

label variable pay "Usual gross pay per month"

codebook pay




* Create low pay variable

gen low_pay=pay
recode low_pay (0.01/1223.99=1) (1224/15000=0)
tab low_pay

lab var low_pay "Respondent is low-paid"

lab def low_paylbl 0 "Not low-paid" 1 "Low-paid"
lab val low_pay low_paylbl

codebook low_pay


*** preferences variable ***
codebook d_scopfamb, t(20)
gen pref_yn=d_scopfamb
recode pref_yn (-9 -8 -7 -2 -1=.) (1 2=1) (3/5=0)
lab var pref_yn " family suffers if mother works full-time"
lab def pref_ynlbl 0 "Does not agree" 1 "Agrees"
lab val pref_yn pref_ynlbl

tab d_scopfamb pref_yn, miss

save "SP201_labdata_1.dta", replace
