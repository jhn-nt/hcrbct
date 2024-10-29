SELECT
    patientunitstayid,
    age,
    gender,
    ethnicity,
    admissionweight AS initial_weight,
    unitdischargestatus AS mortality,
FROM physionet-data.eicu_crd.patient
ORDER BY
    patientunitstayid ASC;