/**********************************************


	Cumulative Do-file SP201

	
**********************************************/


/*  INTRODUCTION TO THIS DO FILE

1.	This do file runs through the coding of all labs for the course.
	I will be updated each week after the labs with codes so that you can
	follow up all lectures should you have missed any.

*   NOTE: Asterix at beginning of line means Stata will know this is a note, 
	not code Highlight individual lines of code then click execute (icon with a 
	piece of paper with triangle picture, above), to run code 
	
	
/**********************************************
		LAB 1 - Recoding variables
**********************************************/

*  The first step anytime you want to explore a dataset is to, indeed, open the dataset
   To do so, use the command "use" and then add the path onto which the computer 
   can retrieve the dataset OR simply drag the datafile into STATA
   The data that we are using in the labs is data from a large, nationally 
   representative sample of people taking part in the Understanding Society survey*/ 
   
use "H:\SP201_labdata_2020.dta" //Add your data path here

* To explore the dataset, use the commands "describe" and "browse" as seen in lecture
* To explore a single variable, type "codebook" followed by the variable of interest

*describe
*browse
*codebook

codebook d_paygu_dv 			// here note 1. the var label, 2.range, 3. missing values

tab d_paygu_dv if d_paygu_dv<0 	// here we explore what the missing values are



/*The information here shows that there 22,137 cases are assigned negative values
 because the pay question did not apply to them. Why would this be the case?  
 By looking at the online documentation, you would see that the pay variable was
 only created for respondents who reported working. Therefore, all non-working 
 respondents were assigned a -8 value. The remaining negative values are due to 
 ‘proxy interviews’ where someone reported the monthly pay of someone else 
 in the household.
 
 We do not want Stata to think that these observations have negative incomes 
 So we recode the variable in six overall steps:

1.	Find a variable that represents what you want to measure

2.	Create a new variable that is a duplicate of the original

3. 	Recode the new variable

4. 	Check the new varaible & compare with old original one

5. 	Label the new variable 

6. 	Label the categories of the new variable (if needed)*/



*STEP I - Find a variable that represents what you want to measure
* For this example we use the variable d_paygu_dv to measure gross monthly income


*STEP II - Create two new variables that are duplicate of the original variable
* One (pay) will be kept as continuous, while the other one will be recoded as binary
gen pay=d_paygu_dv 
gen low_pay=d_paygu_dv


*STEP III - Recode the new variables 
recode pay (-8 -7 =.)     // Keep the variable in its continuous format, 
						  // but with -8, -7 coded as missing

recode low_pay (-8 -7 =.) // Recode it as a binary variable, with -8, -7 coded as missing
recode low_pay (0/1223.99=1)
recode low_pay (1224/max=0)


*STEP IV - Look at new variables and compare them and with the original one
codebook d_paygu_dv
codebook pay
codebook low_pay


*STEP V - Label the new variable
label var pay "Usual gross pay per month - continuous"
label var low_pay "Usual gross pay per month - dichotomous"


*STEP VI - Create labels for categories
label define low_paylbl 0 "Not low paid" 1 "Low paid"
label value low_pay low_paylbl


/* Second example: recoding variable for preferences
Note that here I write a shorter and alternative version of the code, 
but if you find it difficult you can simply use the code above. Both do the same job!
In short, I use recode, followed by the variable I want to recode. Then in 
brackets I tell STATA what and how I want the variables to be recorded and what labels
they should get. Lastly, after the comma, I tell to generate the variable pref2 using 
the new codes.*/

codebook d_scopfamb, tab(100) //tab(100) tells STATA to codebook all values of the variable 

recode d_scopfamb (-9/0=.) (1/2=1 "Agree")(4/5=3 "Disagree") (3=2 "Neither dis/agree"), gen(pref2)

tab d_scopfamb pref2, missing


* Lastly, never forget to save your work

*save "SP201_lab1" //Saves your dataset with the new recoded variables


/******************************************************
		LAB 2 - Descriptive statistics for discrete data
******************************************************/ 
/*  INTRODUCTION TO LAB2 

1.	Here,  we learn how to explore our data with frequency tables
		
2.  We also learn how to create nice graphs in STATA that give us some graphical
	information about the variables we are interested in 
	
	All these forms of descriptive statistics are super helpful to summarise
	our data and give us a hint on the phenomena we are interested in 
	
	Today we are interested in describing the occupational characteristics
	of people in our sample and then to explore how these differ by 
	gender */
	
	
/* 1. First we find the gender variable and generate a new variable that takes 
	  up value 1 for female respondents and 0 for male respondents. 
	  Attach labels to categories. We do the same for the occupation variable*/
	  
codebook d_sex
gen female=d_sex

recode female (2=1) (1=0)
lab var female "Respondent is female"
lab def femalelbl 0 "Male" 1 "Female"
lab val female femalelbl
codebook female
tab female d_sex, missing 

* 2. We do the same for the occupation variable: Recoding occupation
codebook d_jbnssec8_dv, tab(20)
gen occup=d_jbnssec8_dv
recode occup (-9 -8=.)
lab var occup "Current job: Eight Class NS-SEC"
lab val occup d_jbnssec8_dv
codebook occup, tab(20)
tab occup d_jbnssec8_dv, miss

* 3. We create frequency tables for the variables and for men and women separately
tab occup

tab occup if female==0
tab occup if female==1
tab occup female, col
tab occup female, row

* Questions:
* Do men and women work in the same or in different types of occupations?

* 4. We also look at our variable graphically with a (i) pie chart and (ii) a bar chart
* Remember that a meaningful pie chart has to have 4 main characteristics:
* 1. The variable is discrete
* 2. There are limited categories
* 3. There is enough variation in the percentage of obs in each category
* 4. The categories are mutually exclusive!
graph pie, over(occup)
 
graph bar, over(occup, label(labsize(small) angle(45)))


* Lastly, never forget to save your work
* For graphs, do not forget that you have to save it twice - once in the Stata format (.gph)
* and once in th eformat you like to visualise it out of Stata (e.g. .png, .jpeg)

*save "SP201_lab2" //Saves your dataset with the new recoded variables

 	
/**********************************************
		LAB 3 - Descriptive statistics for continuous data
**********************************************/

/*  INTRODUCTION TO LAB3 

In this lab, we will start looking at the gender pay gap by using descriptive 
statistics to answer whether women in our sample earn less than men. In lecture, 
we discussed that continuous variables, like pay, are summarised by two different 
types of statistics:
	1. Measures of LEVEL: The mean, the median
	2. Measures of SPREAD: Standard deviation, interquartile range
	
	In this lab, we present these descriptive statistics in TABULAR and GRAPHICAL
	form. */
	
	
* 1. To explore our continous variable, we first create
*	 a table of descriptive statistics for the overall sample
summarize pay, detail 

	/* we see that 
	1. Median = 1,590.20
	2. Mean = 1,904.73
	3. Standard deviation = 1510.59
	4. IQR = 1600.00 (2500-900) */

* 2. How does the pay variable look like for women? We can explore
*    this by adding the if statement to our command
summarize pay if female==1, detail

*    And for men?
sum pay if female==0, detail



* 3. We can explore this also graphically for the whole sample
*    using two new graphical tools - histograms and box plots

histogram pay, frequency
	* Note: Most observations are clustered near the bottom of the distribution. 
	*       The distribution is highly skewed with some very high values to the right.
	
graph box pay
	* Note: The top of the box represents the value of the 75th percentile.
	* 		The middle of the box represents the median value.
	* 		The bottom of the box shows the value of the 25th percentile.
	* 		The overall box shows the Interquartile range (75-25)
	* 		The lines are called whiskers and indicate the "maximum" (Q3 + 1.5*IQR)
	*		and the "minimum" (Q1 -1.5*IQR). These indicate the variability outside 
	*		the upper and lower quartiles
	
* Box plot are useful because they show the skewness of a data set 
* For instance, when the median is closer to the bottom of the box, and 
* if the whisker is shorter on the lower end of the box, then the distribution 
* is positively skewed (skewed right). 



* As for the summarize command, you can visualise the pay variable
* for men and women using, this time, the by(var) command
* Always remember to save your graphs twice (.png and .gph formats)

histogram pay, frequency by(female)
graph box pay, by(female)

*save "SP201_lab3"

*******




/**********************************************
		LAB 4 - Recoding variables
**********************************************

*  So far we have described our sample and some of the variables we are interested
   to explore the gender pay gap. We saw that the unadjusted pay gap between men and
   women in our sample is of about £709. 
   However, our goal is to say something about the UK population – not just 
   employed people who responded to Wave 4 of Understanding Society (W4US).
   
   !!!
   
   This week thus marks the shift from using simple descriptive statistics to 
   using different types of inferential statistics in which we try to infer 
   something about our population of interest based on statistics we calculate 
   on our sample.
   
   !!!
   
   1. Weights
	  W4US is based on a complex random sample that is nationally-representative, but also 
	  includes more members of ethnic minority groups and residents of Northern Ireland.
   2. Missing values due to ineligibility or refusal.
	  In practice, researchers check that the missing data do not exclude some groups 
	  more than others (we call this “missing at random”.) 
	  If there is a pattern to missing data, researchers sometimes use techniques 
	  like multiple imputation to create values for the missing data. 
	  In this course, we are simply going to exclude respondents that are missing 
	  data on any of our variables. This is called casewise deletion. In this lab, 
	  you will learn how to delete cases with any missing data using: 
	  
	  the mark and markout commands.
	  
   3. CENTRAL LIMIT THEOREM: if we have the means and standard deviations of two 
      (or more) groups, we can make inferences about whether or not they are from 
	  the same underlying population. In this case, the same underlying population 
	  means that there are no differences between the groups. 
	  
	  
	  PS: a statistically significant result does not tell you whether or not 
	  your study is interesting or is relevant to policy. A statistically 
	  significant results also does not tell you whether or the difference that 
	  you see is large or meaningful. Statistical signficance only:
	  1. Rejects/confirms the null HP
	  2. Shows how unlikely it is to see the difference in the smaple if there were no
	  group differences in the population (p-value)


   */ 
   
* 1. First step today is to recode the work hours
   codebook d_jbhrs if d_jbhrs<0, t(20)
   recode d_jbhrs(-1 -2 -8 -9=.), gen (wk_hrs)
   
   lab var wk_hrs "Number of hours worked per week"
   sum wk_hrs, detail
   
* 2. Then we move to mark out our missing values
   * To do so, we first have to create a new variable that “marks” cases with missing data
   mark nomiss
   
   * Next, we tell Stata the variables that are problematic if they are missing data
   markout nomiss pay female occup wk_hrs pref2
   
   tab nomiss 
   
* 3. We compare estimates between full sample and a sample of respondents with complete data
   * Whole sample first
	 summarize pay female occup wk_hrs pref2

   * Sample with complete data
	 sum pay female occup wk_hrs pref2 if nomiss==1
	

* 4. We want to limit our sample to population of interest. To do so, we can:
*    Create the variable
	 gen sample=0

*    Replace so sample takes the value of 1 for employed women without missing data
	 replace sample=1 if female==1 & nomiss==1
	 tabulate sample //Note that now the sample is much smaller (reduced from from 47,157 to 10,740 obs)
	 
*	 Compare results with different ways of limiting sample
	 sum wk_hrs if sample==1
	 sum wk_hrs if nomiss==1 & female==1 & occup==1


*save "SP201_lab4"



/**********************************************
		LAB 5 - Contingency tables & Chi-square
**********************************************

*  So far we have described our sample and some of the variables we are interested
   to explore the gender pay gap. We saw that there is a pay gap between men and
   women in our sample. 
   However, our goal is to say something about the UK population – not just 
   employed people who responded to Wave 4 of Understanding Society (W4US).
   
   !!! INFERENTIAL STATISTICS
   
   This week thus marks the shift from using simple descriptive statistics to 
   using different types of inferential statistics in which we try to infer 
   something about our population of interest based on statistics we calculate 
   on our sample.
   
   !!!
   
   Inferential statistics allow us to formally test hypotheses about relationships 
   between variables in our population of interest. 
   In lecture, we discussed the four steps of hypothesis testing:

	1.	Specify null and alternative hypotheses
	2.	Set ‘Alpha’
	3.	Conduct statistical analyses and obtain a test statistic and an estimate of the significance level (p-value).
	4.	Decide whether to reject the null hypothesis.
	

* Note here that we have also moved from describing one variable at a time to 
  describing the relationship between variables. Thus, we are also moving beyond 
  univariate to bivariate analyses. 	
  

  In this lab, you will learn how to do so for two categorical variables. 
  Together, we will ask: 
  Are women more likely to be low-paid than men? 
  This research question comes with two hypotheses:
 
		HO: There is no relationship between gender and low-pay.
		HA: There is a relationship between gender and low-pay.

  
*/ 
   
* 1. First step today is to CREATE A CONTINGENCY TABLE   

	*cross-table of frequencies
	tabulate low_pay female if nomiss==1 // Dependent variable listed first

	*add column percentages
	tabulate low_pay female if nomiss==1, column //47.83% of women are low-paid

	*add row percentages
	tabulate low_pay female if nomiss==1, row 

	*add full sample percentages
	tabulate low_pay female if nomiss==1, cell

* 2. Look at the Chi-sq
    tabulate low_pay female if nomiss==1, column chi2 //the probability that your results occurred due to chance alone

*save "SP201_lab5"
