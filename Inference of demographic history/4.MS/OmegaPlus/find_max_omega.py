import pandas as pd
raw_omega = pd.read_csv('max_omega', delimiter='\t', header=0)
#Wraw_omega.val = pd.to_numeric(raw_omega.val, errors='coerce')
raw_omega.val = raw_omega.val.astype(float)
raw_omega.sort_values(by='val', inplace=True, kind="mergesort")
print(raw_omega)