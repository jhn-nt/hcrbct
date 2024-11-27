SELECT
    apache.apachepatientresultsid AS apacheID,
    apache.patientunitstayid,
    apache.apachescore AS apache_score,
    apache.apacheversion AS apache_version,
    apache.predictedhospitalmortality AS pred_mortality,
    apache.actualhospitalmortality AS actual_mortality, 
FROM
    physionet-data.eicu_crd.apachepatientresult as apache
INNER JOIN (
    SELECT DISTINCT
    intake.patientunitstayid,
    FROM physionet-data.eicu_crd.intakeoutput as intake
    WHERE intake.celllabel IN ('Volume-Transfuse red blood cells', 'PRBC', 'pRBCs')
    ) intake ON apache.patientunitstayid=intake.patientunitstayid

