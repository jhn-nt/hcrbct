SELECT
    apachepatientresultsid AS apacheID,
    patientunitstayid,
    apachescore AS apache_score,
    apacheversion AS apache_version,
    predictedhospitalmortality AS pred_mortality,
    actualhospitalmortality AS actual_mortality, 
FROM
    physionet-data.eicu_crd.apachepatientresult
INNER JOIN (
    SELECT DISTINCT
    intake.patientunitstayid,
    FROM physionet-data.eicu_crd.intakeoutput as intake
    WHERE intake.celllabel='Volume-Transfuse red blood cells'
    ) intake ON patientunitstayid=intake.patientunitstayid
