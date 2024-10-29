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
    WHERE intake.celllabel='Volume-Transfuse red blood cells'
    ) intake ON io.patientunitstayid=intake.patientunitstayid

