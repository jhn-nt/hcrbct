SELECT
    patientunitstayid,
    age,
    gender,
    ethnicity,
FROM physionet-data.eicu_crd.patient
ORDER BY
    patientunitstayid ASC;