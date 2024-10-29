import pandas as pd
import pandas_gbq
import os
from pathlib import Path
from typing import Callable

TEMP='/hcrbct'


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



