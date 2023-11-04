import sys
import numpy as np
import nibabel as nib
import csv

try:
    t1divt2 = snakemake.input.t1divt2
    parcellation = snakemake.input.parcellation
    output = snakemake.output[0]
    stat = snakemake.params.stat
except Exception:
    t1divt2 = sys.argv[1]
    parcellation = sys.argv[2]
    output = sys.argv[3]
    stat = "mean"


metric = nib.load(t1divt2).get_fdata().flatten()
parcellation = nib.load(parcellation).get_fdata().flatten()

# get unique parcels, average metric at those unique indices
uniqueparcel = np.unique(parcellation)

with open(output, "w", newline="") as csvfile:
    writer = csv.writer(csvfile, delimiter="\t")
    writer.writerow([f"Parcel index", "Mean"])
    for ii in np.unique(parcellation):
        vals = metric[parcellation == ii]
        if stat == "mean":
            result = np.mean(vals)
        elif stat == "std":
            result = np.std(vals)
        elif stat == "median":
            result = np.median(vals)
        else:
            raise ValueError(f"Unrecognized stat {stat}")
        writer = csv.writer(csvfile, delimiter="\t")
        writer.writerow([ii, result])
