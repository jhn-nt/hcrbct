SELECT
    apachepatientresultsid AS apacheID,
    patientunitstayid,
    apachescore AS apache_score,
    apacheversion AS apache_version,
    predictedhospitalmortality AS pred_mortality,
    actualhospitalmortality AS actual_mortality, 
FROM
    physionet-data.eicu_crd.apachepatientresult
ORDER BY
    patientunitstayid ASC