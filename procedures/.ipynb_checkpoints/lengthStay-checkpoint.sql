SELECT 
    time.patientunitstayid, 
    time.patienthealthsystemstayid,
    time.unitdischargeoffset AS ICU_Stay,
    time.hospitalAdmitOffset AS Time_prior_ICU,
    time.hospitalDischargeOffset,	
FROM physionet-data.eicu_crd.patient time
INNER JOIN (
    SELECT DISTINCT
    intake.patientunitstayid,
    FROM physionet-data.eicu_crd.intakeoutput as intake
    WHERE intake.celllabel IN ('Volume-Transfuse red blood cells', 'PRBC', 'pRBCs')
    ) intake ON time.patientunitstayid=intake.patientunitstayid