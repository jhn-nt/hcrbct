SELECT 
    intake.patientunitstayid,
    intake.intakeoutputid AS itemid,
    intake.intakeoutputoffset AS offset,
    intake.celllabel AS item,
    intake.cellvaluenumeric AS value,
    REGEXP_EXTRACT(intake.cellpath,r'(?:[a-zA-Z\s]*)\s\((?:[a-zA-Z]*)\)\|(?:[a-zA-Z\s]*)\s\(([a-zA-Z]*)\)\|(?:[a-zA-Z\s]*)') AS unit
FROM physionet-data.eicu_crd.intakeoutput as intake
WHERE intake.celllabel='Volume-Transfuse red blood cells'