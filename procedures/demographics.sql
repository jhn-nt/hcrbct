SELECT
    patientunitstayid,
    age,
    gender,
    ethnicity,
    apacheadmissiondx AS admit_diagnosis,
    admissionweight AS initial_weight,
    CASE 
        WHEN unitdischargelocation = 'Death' THEN 'deceased'
        ELSE 'discharged'
    END AS icu_outcome,
    CASE 
        WHEN hospitaldischargelocation = 'Death' THEN 'deceased'
        ELSE 'discharged'
    END AS hosp_outcome
FROM
    physionet-data.eicu_crd.patient
WHERE
    apacheadmissiondx NOT IN (
        'Bleeding-lower GI, surgery for',
        'Complications of prev. peripheral vasc. surgery,surgery for (i.e.ligation of bleeder, exploration and evacuation of hematoma, debridement, pseudoaneurysms, clots, fistula, etc.)',
        'Bleeding, GI-location unknown',
        'Bleeding, lower GI',
        'Bleeding, upper GI',
        'GI perforation/rupture, surgery for',
        'Bleeding, GI from esophageal varices/portal hypertension',
        'GI perforation/rupture',
        'Complications of previous GI surgery; surgery for (anastomotic leak, bleeding, abscess, infection, dehiscence, etc.)',
        'Hemorrhage (for gastrointestinal bleeding GI-see GI system) (for trauma see Trauma)',
        'Complications of previous open-heart surgery, surgery for (i.e. bleeding, infection, mediastinal rewiring,leaking aortic graft etc.)',
        'Renal bleeding',
        'Bleeding-upper GI, surgery for',
        'Bleeding-other GI, surgery for',
        'Complications of previous open heart surgery (i.e. bleeding, infection etc.)'
    )
ORDER BY
    patientunitstayid ASC;
