# Mental Health Distress Analysis

## **Analytical Question:** 
Which sociodemographic and behavioral factors best predict poor mental health days among U.S. adults, and can individuals at risk be classified for frequent mental distress?


## **About this project:**
Mental health was selected for this analysis because of my background in working with adults with mental illness. From my previous experience, I understand the impact that poor mental health has on both individuals and families. Expanding the analysis to include demographic, behavioral, and health factors can help hone in on which factors clinicians may want to pay special attention to in determining who may benefit from further conversations or resources for mental wellness.


## **Dataset:** 
* CDC BRFSS 2023
* 2023 was selected because it has been out longer than the 2024 dataset, has community support, and has existing tutorials.
* The 2023 dataset has 433,323 records.
* This analysis uses 25 out of 350 variables.
* The 2023 data set is available in SAS XPT format and can be downloaded from https://www.cdc.gov/brfss/annual_data/annual_2023.html  


## **Methods overview:**
Data cleaning involved replacing all "None" responses with `0` and replacing all "Don't know or Not sure", "Refused", or "Missing" responses with `NaN`. Further refinement was done to drop missing values for target variables and to replace missing values for all other variables with 0. Feature engineering included creating an an indicator column for missing values in INCOME3 and imputing missings with the median for INCOME3 and mode for categorical variables with under 5% missings. Additionally, binary variables including SEXVAR, _HLTHPL1, _URBSTAT, ADDEPEV3, ASTHMA3, CHCCOPD3, CVDINFR4, EXERANY2, HAVARTH4, MEDCOST1, PERSDOC3 were recoded to 0/1. Lastly, _MENT14D was binned for the classification model so that 0 was for no frequent mental distress (0 - 13 days) and 1 was for frequent distress (14 or more days).

Modeling was completed for both Linear/Logistic Regression as well as Random Forest Models. There were two models used for all models: "Model A" which includes the depression diagnosis variable and "Model B" which excludes the depression diagnosis variable.


## **Key Findings:**
* The data is heavily skewed towards people reporting none, or less than 13, poor mental health days. Approximately 14% of individuals reported having frequent mental distress with 14 or more poor mental health days per month.
* For the demographic variables explored, more education and higher income are related to a lower number of poor mental health days, regardless of an urban vs rural location.
* In examining feature importance, the results are consistent in showing that age, physical health, general health, and income are important features for predicting who may have more frequent mental health distress.
* People with a depression diagnosis report an average of ~11 poor mental health days per month compared to ~2.5 to people without a depression diagnosis (more than a 4x difference).
* Including a depression diagnosis consistently outperforms excluding a depression diagnosis across every metric, confirming that depression diagnosis is a powerful predictor. 
* Regression models explained a limited proportion of variance in poor mental health days (R²=0.28 for best model), suggesting that survey-based sociodemographic factors alone capture only part of what drives mental health outcomes.
* This survey should not be used alone for predicting mental distress in individuals.
    *   The best performing model ("LR Model A (balanced)") catches 73% of frequent distress cases — 27%  of cases are still missed; precision of 0.35 shows that many people would be unnecessarily flagged.
    *   The "LR Model A (balanced)" could be useful as one input among many in a clinical decision support tool, but not as a standalone screener.


## **Limitations:**
* Sleep data was excluded since it was not present in the February 2025 modified release of the 2023 BRFSS file.
* Heaping is present in the data for "rounded" numbers of 5, 10, 15, 20, etc days, which is common for self-reported data.
* People that reported to not smoking or drinking weren't asked the question(s) about how often they drink/smoke so there is a smaller sample size for smoking and drinking related to number of mental health days.
* Exercise is associated with better mental health but need to consider social desirability bias in case exercise is being self-reported at a higher rate than is actually occurring.
    * Also need to consider reverse causality (bidirectional causality) between exercise and mental health: does more exercise mean better mental health or does better mental health mean more exercise....or both?


## **How to run the notebooks:**
Notebooks should be run in the following order:
1. 00_data_load_check
2. 01_data_cleaning
3. 02_eda
4. 03_feature_engineering
5. 04_modeling_regression
6. 05_modeling_classification


## **Libraries Required:**
* pandas
* numpy
* matplotlib
* seaborn
* scikit-learn
