# Multiple-Linear-and-Support-Vector-Regression
Multiple Regression  and Support vector machine for Superstore dataset to  predict future sales from Superstore data.
Superstore data contain the records of the online sales of the Home, office and Electronic products. Dataset contains 10004 rows and 13 columns. Predictive analysis is done on the data and Sales is identified as the dependent variable. As sales is continuous variable Regression problem is identified and regression models are used.

KDD Process is used as a methodology for a Data Mining approach.
These steps includes.
 Acquiring the dataset from data source
 Importing the important libraries
 Importing the datasets from source
 Identifying missing values and handling them
 Converting categorical variables 
 Splitting data
 Feature scaling dat

> Data cleaning and pre-processing: The first step to clean the data is to find the missing values. Missing values are checked by using sapply() function. Using missmap() function from “Amelia” package, map is created to compare observed values and missing values

> Checking outliers: Data was checked for the outliers. Outliers were checked by using boxplots and Rosner’s test. Rosner’s test is generalized test to detect the outliers. Rosner’s test is executed by using rosnerTest() function from “EnvStats” package

> Data reduction and transformation: In this process outliers are handled and insignificant columns are dropped by checking correlation between independent and dependent variables. Outliers are handled by using one of the feature scaling technique called normalization. Log transformation is applied to normalize the range for the column ‘Sales’ and handle outliers

> Correlations: Once the data is normalized, variables are checked for the correlations. Different correlations are used to compare in order to find meaningful independent variables. On this data ‘Pearson’ and ‘Kendall’ correlations are used. This is done by using rcorr() function from “Hmisc” package. 

> Implementation of model: Multiple Linear Regression by using lm() function and Support Vectore Regressor using svm() function from “e1071” package are used for model implementation.

> Evaluation: Annova Table, RMSE and NRMSE from “Metrics” package can be used to evalue the results for Multiple regression and SVM_Type, Gamma value and R2 are used to evaluate results for SVM Regression.
