SELECT 
    lab.patientunitstayid,
    lab.labid AS itemid,
    lab.labresultoffset AS offset,
    lab.labname AS item,
    lab.labresult AS value,
    lab.labmeasurenamesystem AS unit
FROM physionet-data.eicu_crd.lab lab
WHERE labname='Hgb' 