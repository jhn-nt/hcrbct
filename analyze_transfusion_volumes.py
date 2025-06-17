import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats

df = pd.read_csv('df.csv')
print("\nBasic Statistics of Transfusion Volumes:")
print(df['treatment_value'].describe())

percentiles = [25, 50, 75, 90, 95, 99]
print("\nPercentiles:")
for p in percentiles:
    print(f"{p}th percentile: {df['treatment_value'].quantile(p/100):.2f} ml")

# Histogram
plt.figure(figsize=(12, 6))
plt.hist(df['treatment_value'], bins=100, edgecolor='black')
plt.title('Distribution of Transfusion Volumes')
plt.xlabel('Volume (ml)')
plt.ylabel('Count')
plt.grid(True, alpha=0.3)

mean_vol = df['treatment_value'].mean()
median_vol = df['treatment_value'].median()
plt.axvline(mean_vol, color='r', linestyle='--', label=f'Mean: {mean_vol:.2f} ml')
plt.axvline(median_vol, color='g', linestyle='--', label=f'Median: {median_vol:.2f} ml')
plt.legend()
plt.xlim(0, 2000)

plt.savefig('transfusion_volume_distribution.png')
plt.close()

# Try to identify natural groupings using KDE
kde = stats.gaussian_kde(df['treatment_value'].dropna())
x_range = np.linspace(df['treatment_value'].min(), df['treatment_value'].max(), 1000)
density = kde(x_range)

# Find peaks in the density
from scipy.signal import find_peaks
peaks, _ = find_peaks(density, height=0)
peak_volumes = x_range[peaks]

print("\nPotential natural groupings (peaks in distribution):")
for i, vol in enumerate(peak_volumes, 1):
    print(f"Peak {i}: {vol:.2f} ml")
# Most common peak is 330ml, peaks are also spaced out by ~330ml 

# Calculate the percentage of values within different ranges
ranges = [(0, 100), (100, 200), (200, 300), (300, 400), (400, 500), (500, float('inf'))]
print("\nPercentage of values in different ranges:")
for start, end in ranges:
    count = len(df[(df['treatment_value'] >= start) & (df['treatment_value'] < end)])
    percentage = (count / len(df)) * 100
    print(f"{start}-{end if end != float('inf') else 'inf'} ml: {percentage:.2f}%") 

# Decided to use 330ml as the value for one unit of transfusion