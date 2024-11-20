SELECT 
    lab.patientunitstayid,
    lab.labid AS itemid,
    lab.labresultoffset AS offset,
    lab.labname AS item,
    lab.labresult AS value,
    lab.labmeasurenamesystem AS unit
FROM physionet-data.eicu_crd.lab lab
INNER JOIN (
    SELECT DISTINCT
    intake.patientunitstayid,
    FROM physionet-data.eicu_crd.intakeoutput as intake
    WHERE intake.celllabel IN ('Volume-Transfuse red blood cells', 'PRBC', 'pRBCs')
    ) intake ON lab.patientunitstayid=intake.patientunitstayid
WHERE labname='Hgb' 