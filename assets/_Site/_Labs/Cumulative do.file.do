/**********************************************
		LAB 1 - Recoding variables
**********************************************/

*  The first step anytime you want to explore a dataset is to, indeed, open the dataset. To do so, use the command "use" and then add the path onto which the computer can retrieve the dataset OR simply drag the datafile into STATA.
The data that we are using in the labs is data from a large, nationally representative sample of people taking part in the Understanding Society survey*/ 

cd "insert here your working directory"
use "SP201_labdata_2020.dta" //Add your data path here

* To explore the dataset, use the commands "describe" and "browse" as seen in lecture
* To explore a single variable, type "codebook" followed by the variable of interest

codebook d_paygu_dv *here note 1. the var label, 2.range, 3. missing values

tab d_paygu_dv if d_paygu_dv<0 *here we explore what the missing values are


/*The information here shows that there 22,137 cases are assigned negative values
 because the pay question did not apply to them. Why would this be the case?  
 By looking at the online documentation, you would see that the pay variable was
 only created for respondents who reported working. Therefore, all non-working 
 respondents were assigned a -8 value. The remaining negative values are due to 
 ‘proxy interviews’ where someone reported the monthly pay of someone else 
 in the household.
 
We do not want Stata to think that these observations have negative incomes 
So we recode the variable in six overall steps:

1.Find a variable that represents what you want to measure

2.Create a new variable that is a duplicate of the original

3.Recode the new variable

4.Label the new variable 

5.Label the categories of the new variable (if needed)

6.Check the new variable & compare with old original one
*/

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


*STEP IV - Label the new variable
label var pay "Usual gross pay per month - continuous"
label var low_pay "Usual gross pay per month - dichotomous"


*STEP V - Create labels for categories
label define low_paylbl 0 "Not low paid" 1 "Low paid"
label value low_pay low_paylbl

*STEP VI - Look at new variables and compare them and with the original one
codebook d_paygu_dv
codebook pay
codebook low_pay


/* Group work: recoding a 3-category preference variable (pref2) that we will use in the remaining labs. The 3 categories are agree, neither agree/disagree, and disagree

* STEP I
codebook d_scopfamb, tab(100) //tab(100) tells STATA to codebook all values of the variable 

* STEP II
gen pref2 = d_scopfamb

* STEP III
recode pref2 (-9/0=.) (1/2=1)(4/5=3) (3=2)


* STEP IV
label var pref2 "Family/Work balance preference"

* STEP V
label define pref2 1"Agree" 2"Neither agree/disagree" 3"Disagree"
label values pref2 pref2

* STEP VI
codebook d_scopfamb, t(10) 
codebook pref2, t(10)
tab d_scopfamb pref2, missing


/* A shorter and alternative version for step II and III can also be written as below. If you find it difficult you can simply use the code above. Both do the same job! In short, I use recode, followed by the variable I want to recode. Then in brackets I tell Stata what and how I want the variables to be recorded and what labels they should get. Lastly, after the comma, I tell to generate the variable pref2 using  the new codes.*/
recode d_scopfamb (-9/0=.) (1/2=1 "Agree")(4/5=3 "Disagree") (3=2 "Neither dis/agree"), gen(pref2)

* Lastly, never forget to save your work

save "SP201_lab1" //Saves your dataset with the new recoded variables





/******************************************************
LAB 2 – Generate tables and graphs for categorical variables
******************************************************/ 
/*  INTRODUCTION TO LAB2 

1.Here, we learn how to explore our data with frequency tables
		
2.We also learn how to create nice graphs in STATA that give us some graphical
information about the variables we are interested in */
	
	

/* 1.First we find the gender variable and generate a new variable that takes up value 1 for female respondents and 0 for male respondents. Attach labels to categories. We do the same for the occupation variable*/
	  
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
tab occup

* 3. We also look at our variable graphically with a (i) pie chart and (ii) a bar chart
graph pie, over(occup) legend(pos(bottom)) note("Source: Understanding Society, Wave 4. N Obs: 26,547") title("Distribution of occupation in sample, 2012-2014")
 
graph bar, over(occup, label(labsize(small) angle(45))) legend(pos(bottom)) note("Source: Understanding Society, Wave 4. N Obs: 26,547") title("Distribution of occupation in sample, 2012-2014") 

*For the group work, we create frequency tables for the variables and for men and women separately

tab occup if female==0
tab occup if female==1


* Lastly, never forget to save your work

*save "SA201_lab2" //Saves your dataset with the new recoded variables












/************************************************************/
	LAB 3 - Descriptive statistics for continuous data
************************************************************/

/*  INTRODUCTION TO LAB3 

In this lab, we will start looking at the gender pay gap by using descriptive 
statistics to answer whether women in our sample earn less than men. In lecture, 
we discussed that continuous variables, like pay, are summarised by two different 
types of statistics:
	1. Measures of LEVEL: The mean, the median
	2. Measures of SPREAD: Standard deviation, interquartile range
	
In this lab, we present these descriptive statistics in TABULAR and GRAPHICAL form. */
	
	
* 1. To explore our continous variable, we first create
*	 a table of descriptive statistics for the overall sample
summarize pay, detail 

* 2. We can explore this also graphically for the whole sample using two new graphical tools - histograms and box plots

histogram pay, frequency note("Source: Understanding Society, Wave 4. N Obs: 21,080") title("Gross monthly pay of respondents, 2012-2014")
* Note: Most observations are clustered near the bottom of the distribution. 
*       The distribution is highly skewed with some very high values to the right.
	
graph box pay, title("Gross monthly pay of respondents, 2012-2014")  note("Source: Understanding Society, Wave 4. N Obs: 21,080")
	
* Note: The top of the box represents the value of the 75th percentile.
	* The middle of the box represents the median value.
	* The bottom of the box shows the value of the 25th percentile.
	* The overall box shows the Interquartile range (75-25)
	* The lines are called whiskers and indicate the "maximum" (Q3 + 1.5*IQR) 	and the "minimum" (Q1 -1.5*IQR). These indicate the variability outside the 	upper and lower quartiles
	
* Box plot are useful because they show the skewness of a data set 
* For instance, when the median is closer to the bottom of the box, and 
* if the whisker is shorter on the lower end of the box, then the distribution 
* is positively skewed (skewed right). 

* 3. For the group work we asked how does the pay variable look like for women? We can explore this by adding the if statement to our command
summarize pay if female==1, detail

*    And for men?
summarize pay if female==0, detail

* As for the summarize command, you can visualise the pay variable
* for men and women using, this time, the by(var) command
* Always remember to save your graphs twice (.png and .gph formats)

histogram pay, frequency by(female)
graph box pay, by(female)

*save "SP201_lab3" //Saves your dataset with the new recoded variables






/**********************************************
		LAB 4 - Recoding variables
**********************************************

* So far we have described our sample and some of the variables we are interested
to explore the gender pay gap. We saw that the unadjusted pay gap between men and women in our sample is of about £709. However, our goal is to say something about the UK population – not just employed people who responded to Wave 4 of Understanding Society (W4US).
   
   !!!
   
   This week thus marks the shift from using simple descriptive statistics to 
   using different types of inferential statistics in which we try to infer 
   something about our population of interest based on statistics we calculate 
   on our sample.
   
   !!!

*/ 
   
* 1. First step today is to recode the work hours
codebook d_jbhrs if d_jbhrs<0, t(20)
recode d_jbhrs(-1 -2 -8 -9=.), gen (wk_hrs)
   
lab var wk_hrs "Number of hours worked per week"
sum wk_hrs, detail
      
* 2. Then we move to mark out our missing values. To do so, we first have to generate a new variable that “marks” cases with missing data
generate nomiss=0
   
* Next, we tell Stata the variables that are problematic if they are missing data
replace nomiss=1 if pay!=. & female!=. & occup!=. & wk_hrs!=. & pref2!=.
tab nomiss
   
   
* 3. We compare estimates between full sample and a sample of respondents with complete data
   * Whole sample first
summarize pay female occup wk_hrs pref2

   * Sample with complete data
sum pay female occup wk_hrs pref2 if nomiss==1
	

* 4. We want to limit our sample to population of interest. To do so, we can:
*    Create the variable
gen sample=0

*  Replace so sample takes the value of 1 for employed women without missing data
replace sample=1 if female==1 & nomiss==1
tab sample //Note that now the sample is much smaller (reduced from from 47,157 to 10,740 obs)
	 
* Compare results with different ways of limiting sample
sum wk_hrs if sample==1
sum wk_hrs if nomiss==1 & female==1 & occup==1

*save "SP201_lab4"






/***************************************************
		LAB 5 - Contingency tables & Chi-square
****************************************************

* In this lab, you will learn how to construct contingency tables for two categorical variables and interpret the output for the question:
Are women more likely to be low-paid than men? 
This research question comes with two hypotheses:
 
		HO: There is no relationship between gender and low-pay.
		HA: There is a relationship between gender and low-pay.
  
*/ 
   
* 1. First step is to CREATE A CONTINGENCY TABLE   

*cross-table of frequencies
tabulate low_pay female if nomiss==1 // Dependent variable listed first

*add column percentages
tabulate low_pay female if nomiss==1, column //47.83% of women are low-paid

*add row percentages
tabulate low_pay female if nomiss==1, row 

*add full sample percentages
tabulate low_pay female if nomiss==1, cell

* 2. Second step is to CREATE A CONTINGENCY TABLE WITH CHI2 TEST  
tabulate low_pay female if nomiss==1, column chi2 *this gives you the probability that your results occurred due to chance alone
	
* Meeting the assumptions
tabulate low_pay female if nomiss==1, expected

*save "SP201_lab5"


/***************************************************
*LAB 7 - Creating and interpreting scatterplots and correlation coefficients
**********************************************************************************

* We will use new types of statistics to examine the relationship between two continuous variables:

• SCATTERPLOTS: describe the relationship between two continuous variables by providing an overall picture of their relationship. 
• CORRELATION: is a type of inferential statistic that provides a single number summary of the strength of the relationship between two continuous variables. Correlation can be examined and is described by two summary numbers:
1. Pearson’s correlation coefficient 
2. Spearman’s rho.
*/ 
   
* 1. First step is to use scatterplots to examine the relationship between work hours and pay 
scatter pay wk_hrs if nomiss==1,	note("Source: Understanding Society, Wave 4. N Obs: 19,340") title("Scatterplot of pay and work hours") 
	*positive relationship between work hours and earnings
	
* add best-fit line explaining the relationship
scatter pay wk_hrs if nomiss==1 || lfit pay wk_hrs if nomiss==1,	note("Source: Understanding Society, Wave 4. N Obs: 19,340") title("Scatterplot of pay and work hours")


* 2. Look at correlation with Pearson's correlation coefficient
pwcorr pay wk_hrs if nomiss==1, sig

/*The Pearson correlation coefficient, r=0.4994, demonstrates that 
the relationship between hours and pay is positive, and the value 
at the bottom (0.000) is the p-value, denoting significance
	 
	 
But remember the assumptions of the Pearson correlation coefficient:
• The cases represent a random sample from the population; 
• Observations are independent from one another; 
• There is a linear relationship between the variables of interest; and, 
• Each of your variables should be approximately normally distributed */

*3. Look at correlation with Spearman's rho (is less influenced by outlying observations)
spearman pay wk_hrs if nomiss==1 //still reject the null hypothesis that there is no relationship between these variables. 

* For the group work, we ask to look at another way to address the assumptions of the Pearsons’ correlation coefficient, i.e. to transform a variable. We can transform a variable into its logarithm form using commands we already learned:

generate log_pay=log(pay)
hist log_pay	

*save "SP201_lab7


/**********************************************************************************LAB 8 - Introduction to Linear Regression (CONTINUOUS DEPDENDENT VARIABLE)
**********************************************************************************

* RESEARCH QUESTION: 
  Are women paid significantly less than men, after adjusting for the effects 
  of work hours, occupation, and personal preferences?  
 
* HYPOTHESES:
	HO: There is no relationship between gender and pay, after controlling for 
		worked hours, occupation, and personal preferences
	HA: There is a relationship between gender and pay, after controlling for 
		worked hours, occupation, and personal preferences */
		
regress pay i.female if nomiss==1
  
/* 
- F-test: testing the null hypothesis that the model you have specified is not 
any better than a model that includes no predictors at all. 
- R-squared:  percentage of the variance in the dependent variable explained with the variables in our model  
- b0 is the value of our constant or intercept. This is our estimated wages when the value of our predictor variable(s) equals 0.
- b1: our regression coefficient for gender, estimate of the population value based on our sample. The size of b1 and its standard errors determine the t-test and associated p-value.
- 95% C.I.: we are 95% confident that women earn between £808- £890 less than men in the British working population
	 
From our model we see that there is a significant relationship between monthly earnings and gender. 
Gender explains about 7.6% the variance in monthly earnings among British working adults 
(F(1, 17742)= 1459.51, p<.001). 
While men earn approximately £2,386 per month, monthly earnings for women are only £1,537. Thus, our estimate of the unadjusted pay gap is £849. */


* (3) Start adjusting for mediator variables */
regress pay i.female i.pref2 if nomiss==1

*/Even after including preferences in the model, a significant difference in  monthly earnings remained between men and women. For example, among British adults who disagree with the statement that a family suffers if a mother works full time predicted monthly earnings for men are £2,522, while those of women are only £1,656. 	*/

* Now for a dependent variable transformed to the log scale
regress log_pay i.female i.pref2 wk_hrs i.occup if nomiss==1
display exp(-0.0997975)
display 1-0.90502067
0.09497933*100

*save "SP201_lab8"


**********************************************************************************
	LAB 9 - LOGISTIC REGRESSION MODELS
************************************************************************************/
Our research question and hypotheses for this lab are:
•	Research question: Are women more likely to be low-paid than men, after controlling for covariates?
•	H0: There is no relationship between gender and low-pay, after controlling for covariates
•	HA: There is a relationship between gender and low-pay, after controlling for covariates
*/

* 1. Run the first logistic regression of your life with only the variable female
logit low_pay i.female if nomiss==1

* 2. Obtain the predicted probabilities
margins female

* 3. Graph the results
marginsplot

* 4. Run the second logistic regression of your life now controlling for work hours
logit low_pay i.female wk_hrs if nomiss==1
	
margins female, at((mean)wk_hrs) vsquish 
	
margins female, at(wk_hrs=40) vsquish /*This allows calculating predicted probabilities at specific values  */
	
*5. Run the third logistic regression of your life now controlling for work hours, occupation and preferences
logit low_pay i.female wk_hrs i.occup i.pref2 if nomiss==1
margins female, at(wk_hrs=40 occup=2 pref2=3) vsquish

*6. Check sparseness
tab low_pay occup if nomiss==1
tab low_pay occup if nomiss==1 & female==1
tab low_pay occup if nomiss==1 & female==1 & pref2==1

gen occup2=occup
recode occup2 (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7)
lab def occup2 1 "Higher professional/managerial" 2 "Lower management and professional" 3 "Intermediate" 4 "Small employers and own account" ///
5 "Lower supervisory/lower technical" 6 "Semi-routine" 7 "Routine"
lab val occup2 occup2
tab occup occup2

*7. Produce a regression table
	logit low_pay i.female if nomiss==1
	logit low_pay i.female i.pref2 wk_hrs i.occup2  if nomiss==1
	
*save "SP201_lab9"
	 
