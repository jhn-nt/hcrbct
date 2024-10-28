SELECT
    patientunitstayid,
    age,
    gender,
    ethnicity,
    admissionweight AS initial_weight,
    dischargeweight AS final_weight,
FROM physionet-data.eicu_crd.patient
ORDER BY
    patientunitstayid ASC;