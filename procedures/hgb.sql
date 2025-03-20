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




-- WITH transfused_patients AS (
--     -- Get unique patient IDs who had a transfusion
--     SELECT DISTINCT patientunitstayid
--     FROM physionet-data.eicu_crd.intakeoutput
--     WHERE celllabel IN ('Volume-Transfuse red blood cells', 'PRBC', 'pRBCs')
-- ),
-- sepsis_diagnosis AS (
--     -- Get earliest sepsis diagnosis per patient
--     SELECT patientunitstayid, 
--            MIN_BY(diagnosisstring, diagnosisoffset) AS diagnosisstring,
--            MIN(diagnosisoffset) AS diagnosisoffset
--     FROM physionet-data.eicu_crd.diagnosis
--     WHERE diagnosisstring LIKE "%sepsis%"
--     GROUP BY patientunitstayid
-- )
-- SELECT
--     lab.patientunitstayid,
--     lab.labid AS itemid,
--     lab.labresultoffset AS offset,
--     lab.labname AS item,
--     lab.labresult AS value,
--     lab.labmeasurenamesystem AS unit,
--     sepsis_diagnosis.diagnosisstring,
--     sepsis_diagnosis.diagnosisoffset
-- FROM physionet-data.eicu_crd.lab lab
-- INNER JOIN transfused_patients ON lab.patientunitstayid = transfused_patients.patientunitstayid
-- LEFT JOIN sepsis_diagnosis ON lab.patientunitstayid = sepsis_diagnosis.patientunitstayid
-- WHERE lab.labname = 'Hgb'
-- AND sepsis_diagnosis.diagnosisstring <> 'null'
-- ORDER BY lab.patientunitstayid;