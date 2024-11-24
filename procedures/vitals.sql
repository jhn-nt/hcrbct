SELECT 
    vitals.patientunitstayid,
    vitals.observationoffset AS offset,
    vitals.sao2 AS SaO2,
    vitals.heartrate,
    vitals.respiration,
    vitals.systemicmean AS bp 
FROM physionet-data.eicu_crd.vitalperiodic vitals
INNER JOIN (
    SELECT DISTINCT 
    intake.patientunitstayid,
    FROM physionet-data.eicu_crd.intakeoutput as intake
    WHERE intake.celllabel IN ('Volume-Transfuse red blood cells', 'PRBC', 'pRBCs')
    ) intake ON vitalperiodic.patientunitstayid=intake.patientunitstayid

-- WHERE patientunitstayid IN (ids_placeholder)


