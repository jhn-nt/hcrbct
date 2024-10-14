SELECT 
  io.patientunitstayid,
  io.intakeoutputoffset AS offset,
  io.outputtotal,
  io.intaketotal,
  io.dialysistotal,
  io.nettotal,
  io.celllabel
FROM physionet-data.eicu_crd.intakeoutput io
