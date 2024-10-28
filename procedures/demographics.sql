SELECT
    patientunitstayid,
    age,
    gender,
    ethnicity,
    admissionweight AS initial_weight,
    CASE 
        WHEN unitdischargelocation='Death' THEN 'deceased'
            ELSE 'discharged' END AS icu_outcome,
    CASE 
        WHEN hospitaldischargelocation='Death' THEN 'deceased'
            ELSE 'discharged' END AS hosp_outcome 
FROM physionet-data.eicu_crd.patient
ORDER BY
    patientunitstayid ASC;