SELECT 
  io.patientunitstayid,
  io.intakeoutputoffset AS offset,
  io.outputtotal,
  io.intaketotal,
  io.dialysistotal,
  io.nettotal,
  io.celllabel
FROM physionet-data.eicu_crd.intakeoutput io
INNER JOIN (
    SELECT DISTINCT
    intake.patientunitstayid,
    FROM physionet-data.eicu_crd.intakeoutput as intake
    WHERE intake.celllabel IN ('Volume-Transfuse red blood cells', 'PRBC', 'pRBCs')
    ) intake ON io.patientunitstayid=intake.patientunitstayid

