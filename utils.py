import pandas as pd
import pandas_gbq
import os
from pathlib import Path
from typing import Callable
from tableone import TableOne
import numpy as np


TEMP='/hcrbct'


# classify admit_diagnosis into categories
def classify_condition_category(diagnosis):
    if pd.isna(diagnosis):
        return np.nan

    diagnosis = diagnosis.lower()

    categories = {
        "Hematologic": ["leukemia", "lymphoma", "anemia", "coagulopathy", "pancytopenia", "thrombocytopenia", "neutropenia", "sickle cell", "hematologic"],
        "Renal": ["renal", "nephrectomy", "kidney", "dialysis", "ureter", "uti"],
        "Respiratory": ["asthma", "pneumonia", "pulmonary", "bronchitis", "respiratory", "lung", "thoracotomy", "aspiration", "pleural", "tracheostomy"],
        "Cardiac": ["cardiac", "heart", "mi", "infarction", "angina", "arrhythmia", "valve", "rhythm", "cabg", "effusion", "pericardial", "cardiomyopathy", "transplant"],
        "Neurologic": ["stroke", "cva", "seizure", "encephalopathy", "neurologic", "coma", "meningitis", "spinal", "brain", "head", "subdural", "epidural", "cranial", "hydrocephalus"],
        "Oncologic": ["cancer", "neoplasm", "tumor", "mastectomy", "lymphoma", "leukemia"],
        "Gastrointestinal": ["pancreatitis", "gi", "bowel", "hepatic", "liver", "cholangitis", "abdomen", "colon", "rectal", "gastr", "esophageal", "diverticular", "ileal", "gallbladder", "appendectomy"],
        "Infectious": ["sepsis", "infection", "abscess", "cellulitis"],
        "Endocrine/Metabolic": ["diabetic", "hypoglycemia", "hyperglycemic", "thyroid", "addisons", "metabolic", "adrenal"],
        "Musculoskeletal/Orthopedic": ["fracture", "arthritis", "replacement", "amputation", "orthopedic", "spine", "hip", "knee"],
        "Obstetric/Gynecologic": ["pregnancy", "cesarean", "hysterectomy", "oophorectomy", "pelvic", "cyst", "ectopic"],
        "Trauma": ["trauma", "injury", "wound", "contusion", "hematoma"],
        "Vascular": ["aneurysm", "thrombosis", "embolus", "graft", "endarterectomy", "bypass", "vascular"],
        "Autoimmune/Immune": ["lupus", "vasculitis", "myositis", "connective tissue"],
    }

    for category, keywords in categories.items():
        if any(keyword in diagnosis for keyword in keywords):
            return category

    return "Other"


# Function to check for partial match
def find_condition_type(diagnosis, category="hematologic"):
    keyword_map = {
        "hematologic": {
            "leukemia": "Leukemia",
            "pancytopenia": "Pancytopenia",
            "coagulopathy": "Coagulopathy",
            "thrombocytopenia": "Thrombocytopenia",
            "neutropenia": "Neutropenia",
            "sickle cell": "Sickle Cell Disease",
            "hematologic": "Hematologic (Other)"
        },
        "kidney": {
            "chronic kidney": "Chronic Kidney Disease",
            "ckd": "Chronic Kidney Disease",
            "renal failure": "Kidney Failure",
            "kidney transplant": "Kidney Transplant",
            "nephrectomy": "Kidney Surgery",
            "renal obstruction": "Renal Obstruction",
            "renal": "Renal Disorder",
            "hepato-renal": "Hepato-Renal Syndrome",
            "dialysis": "Dialysis Access"
        }
    }

    if pd.isna(diagnosis):
        return np.nan

    diagnosis = diagnosis.lower()
    for keyword, label in keyword_map.get(category, {}).items():
        if keyword in diagnosis:
            return label
    return np.nan




def compute_effect_per_unit(row):
    if pd.isna(row['treatment_effect']) or pd.isna(row['treatment_value']):
        return np.nan
    if row['treatment_value'] == 0:
        return np.nan  # or 0 if you prefer, but better to flag division by zero
    if row['treatment_effect'] == 0:
        return 0.0
    return row['treatment_effect'] / (row['treatment_value'] / 330.0)




def read_gbq(query_path:Path,**kwargs)->pd.DataFrame:
    """Thin wrapper around pandas_gbq.read_gbq.
    Behaves like pandas_gbq.read_gbq except for the query parameters that now point to a file and not to a string.
    All other krwargs are passed as normal arguments to pandas_gbq.read_gbq 

    Args:
        query_path (Path): Path to an .sql file containing the query to eun on pandas_gbq.read_gbq

    Returns:
        pd.DataFrame: The dataframe resulted from the query.
    """
    if not Path(TEMP).is_dir():
        os.mkdir(TEMP)

    idx=hex(hash(query_path))
    if (Path(TEMP) / idx).is_file():
        df=pd.read_pickle(Path(TEMP) / idx)
    else:
        query=open(query_path).read()
        df=pandas_gbq.read_gbq(query,**kwargs)
        df.to_pickle(Path(TEMP) / idx)
    return df

def treatment_effect(treatment_df:pd.DataFrame,lookup_df:pd.DataFrame,window_size:int,offset:int,aggfunc:Callable)->pd.DataFrame:
    """Given a treatment timestamp (offset, the transfusion in our case) evaluates wether there exists some readings from lookup table of measurements (HGB in our case):
    baseline:   HgB(treatment.offset-window_size,treatment.offset)
    post_treatment:   HgB(treatment.offset+offset,treatment.offset+offset+window_size)

    Args:
        treatment_df (pd.DataFrame): A dataframe consisting of timestamps for the treatment (ie transfusion). The datframe must contain a column named offset.
        lookup_df (pd.DataFrame): A datframe consiating of timestamps for the lookup (ie HGB). The dataframe must contain a column named offset.
        window_size (int): Window size in hours.
        offset (int): Offset size in hours.
        aggfunc (Callable): Aggregation function (ie mean)

    Returns:
        pd.DataFrame: A datframe with the output.
    """
    # Note for hashem: my code does not enforce that no transfusion overlaps within windows of HGB collection, eventually thismust be enforced
    output=[]
    for _,dt in treatment_df.iterrows():
        delta=lookup_df.offset-dt.offset
        baseline=lookup_df.loc[delta[(delta<0)&(delta>-window_size)].index]
        post_treatment=lookup_df.loc[delta[(delta>offset)&(delta<(window_size+offset))].index]
        output.append(
            {'patientunitstayid':dt.patientunitstayid,
            'baseline':baseline.value.agg(aggfunc), # HGB before transfusion
            'post_treatment':post_treatment.value.agg(aggfunc), # HGB after transfusion
            'treatment_effect':post_treatment.value.agg(aggfunc)-baseline.value.agg(aggfunc), # difference in HGB before and after transfusion
            'treatment_value': dt.value, # volume in ml of the transfusion
            'treatment_offset':dt.offset, # timestamp of the transfusion
            '_offset':offset, # placeholder recalling the offset used
            '_window_size':window_size, # placeholder recalling the window_size used
            'n_baseline':baseline.shape[0], # number of valid HGB readings found before treatment
            'n_post_treatment':post_treatment.shape[0], # number of valid HGB readings found after treatment
            'aggfunc':aggfunc # placeholder recalling the aggregation function used
            }
            )
    return pd.DataFrame(output)


def rename_cols(t1):
    """
    Renames the columns as needed.
    Parameters:
    - t1 (TableOne): An instance of the TableOne class.
    Returns:
    - DataFrame: The modified tableone DataFrame with updated column names.
    """
    table_df=t1.tableone
    table_df.rename(index={
        "Transfusion Volume": "Transfusion Volume (mL)",
        "Time to Transfusion": "Time to Transfusion (hours)",
        "Baseline HGB": "Baseline HGB (g/dL)",
        "HGB Increment": "HGB Increment (g/dL)"
    }, inplace=True)

    rename_dict = {
        'treatment_value, mean (SD)': 'Transfusion Volume (mL), mean (SD)',
        'treatment_offset, mean (SD)': 'Time to Transfusion (hours), mean (SD)',
        'baseline, mean (SD)': 'Baseline HGB (g/dL), mean (SD)',
        'treatment_effect, mean (SD)': 'HGB Increment (g/dL), mean (SD)',
        'netTotal, mean (SD)' : 'Total Fluids (ml), mean (SD)',
        'Total_time, mean (SD)': 'ICU Stay Length (hrs), mean (SD)'
    }


    table_df.index = table_df.index.set_levels([
        [rename_dict.get(label, label) for label in table_df.index.levels[0]],  # First level renamed
        table_df.index.levels[1]  # Keep second level unchanged
    ])

    return table_df