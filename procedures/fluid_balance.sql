--- fluid balance evaluation in the 6 hours before transfusion
SELECT 
  io.patientunitstayid,
  intake.transfusion_offset,
  SUM(DISTINCT io.netTotal) AS netTotal,
  SUM(DISTINCT io.intakeTotal) AS intakeTotal,
  SUM(DISTINCT io.outputTotal) AS outputTotal,
FROM physionet-data.eicu_crd.intakeoutput io
INNER JOIN (
    SELECT DISTINCT
    intake.patientunitstayid,
    intake.intakeoutputoffset AS transfusion_offset
    FROM physionet-data.eicu_crd.intakeoutput as intake
    WHERE intake.celllabel IN ('Volume-Transfuse red blood cells', 'PRBC', 'pRBCs')
    ) intake ON io.patientunitstayid=intake.patientunitstayid
              AND io.intakeoutputoffset BETWEEN intake.transfusion_offset-360 AND intake.transfusion_offset
GROUP BY io.patientunitstayid,intake.transfusion_offset
ORDER BY io.patientunitstayid,intake.transfusion_offset
