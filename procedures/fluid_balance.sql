SELECT 
  io.patientunitstayid,
  io.intakeoutputoffset AS offset,
  io.outputtotal,
  io.intaketotal,
  io.dialysistotal,
  io.nettotal,
  io.celllabel,
  io.cellvaluenumeric
FROM physionet-data.eicu_crd.intakeoutput io
WHERE io.patientunitstayid IN (ids_placeholder);

-- Try filtering patientunitstayid to only include IDs in study


-- SELECT 
--     patientunitstayid, 
--     intakeoutputid AS Intake_ID, 
--     intakeoutputoffset AS offset, 
--     intaketotal, 
--     outputtotal, 
--     dialysistotal,
--     nettotal AS total,
--     cellvaluenumeric AS value,
-- FROM `physionet-data.eicu_crd.intakeoutput` 