
SELECT distinct patientunitstayid 
FROM `physionet-data.eicu_crd_derived.sepsis_from_diagnosis` 
WHERE sepsis=1
ORDER BY patientunitstayid;

-- -- Contains 23479 unique patients with sepsis in their record
-- SELECT patientunitstayid, 
--        MIN_BY(diagnosisstring, diagnosisoffset) AS diagnosisstring,
--        MIN(diagnosisoffset) AS sepsisOffset
-- FROM `physionet-data.eicu_crd.diagnosis`
-- WHERE diagnosisstring LIKE "%sepsis%"
-- GROUP BY patientunitstayid
-- ORDER BY patientunitstayid;


-- -- We need to evaluate which query is best to use. 
-- -- The second query has more restrictions and includes icd9 codes
-- -- First one only filters based on the text "sepsis"

-- -- Contains around 8300 unique patients with sepsis in their record
-- -- SELECT 
-- --     patientunitstayid, 
-- --     MIN_BY(diagnosisstring, diagnosisoffset) AS diagnosisstring,
-- --     MIN(diagnosisoffset) AS sepsisOffset,
-- --     REGEXP_EXTRACT(MIN_BY(diagnosisstring, diagnosisoffset), r'\|([^|]*sep[^|]*)\|?') AS extracted_sepsis_text
-- -- FROM `physionet-data.eicu_crd.diagnosis`
-- -- WHERE REGEXP_CONTAINS(diagnosisstring, r'\|[^|]*sep[^|]*\|')  
-- -- AND icd9code LIKE "%995.9%" 
-- -- GROUP BY patientunitstayid
-- -- ORDER BY patientunitstayid;

