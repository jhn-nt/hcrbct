SELECT 
    intake.patientunitstayid,
    intake.intakeoutputoffset,
    AVG(vitals.sao2) AS SaO2,
    AVG(vitals.heartrate) AS heartrate,
    AVG(vitals.respiration) AS respiration,
    AVG(vitals.systemicmean) AS bp 
FROM physionet-data.eicu_crd.vitalperiodic vitals
INNER JOIN (
    SELECT DISTINCT 
    intake.patientunitstayid,
    intake.intakeoutputoffset
    FROM physionet-data.eicu_crd.intakeoutput as intake
    WHERE intake.celllabel IN ('Volume-Transfuse red blood cells', 'PRBC', 'pRBCs')
    ) intake 
    ON vitals.patientunitstayid=intake.patientunitstayid
    AND vitals.observationoffset BETWEEN intake.intakeoutputoffset-360 AND intake.intakeoutputoffset
GROUP BY intake.patientunitstayid,intake.intakeoutputoffset