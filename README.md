See `bench.ipynb` for example usage.

### TODOS
* Feature A: Number of patients with at least 1 hgb reading [1,6,12]H before transfusion and [1,6,12]H after transfusion without any other tranfusion before or after (we need to agree on a name for this feature)
* Table 1 total and stratified by weight, gender and major ICD9: # patients, median LOS [IQR], median hgb [IQR], median transfusion volume [IQR], median blood loss  [IQR], median # hgb measurements per patients [IQR], median # transfusions per patients [IQR], median # number blood loss measurements per patients [IQR], mortality rate %
* Variance across hospitals: compute table 1 features per each hospitals and compare them
* Variance across most common diagnosis: compute table 1 features per major diagnosis and compare them
* Regression on feature A using table 1 features as covariates, is there a trend we can observe? 
