SELECT 
    intake.patientunitstayid,
    intake.intakeoutputid AS itemid,
    intake.intakeoutputoffset AS offset,
    'Blood Loss' AS item,
    intake.cellvaluenumeric AS value,
    REGEXP_EXTRACT(intake.cellpath,r'\|(?:[a-zA-Z\s]*)\s\(([a-zA-Z]*)\)') AS unit
FROM physionet-data.eicu_crd.intakeoutput as intake
INNER JOIN (
    SELECT DISTINCT
    intake.patientunitstayid,
    FROM physionet-data.eicu_crd.intakeoutput as intake
    WHERE intake.celllabel='Volume-Transfuse red blood cells'
    ) idx ON idx.patientunitstayid=intake.patientunitstayid
WHERE intake.celllabel IN ('Blood Loss','Estimated Blood Loss')