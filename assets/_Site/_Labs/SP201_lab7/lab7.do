************
*** Lab 7 do file
**************

regress pay i.female if nomiss==1

regress pay i.female i.pref2 if nomiss==1

regress pay i.female i.pref2 wk_hrs i.occup if nomiss==1
