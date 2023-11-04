#!/bin/bash

subject="001"

mkdir -p "results/sub-${subject}/anat"

echo "Averaging t1w images"
mrmath \
    "data/sub-${subject}/anat/sub-${subject}_run-1_space-acpc_T1w.nii.gz"\
    "data/sub-${subject}/anat/sub-${subject}_run-2_space-acpc_T1w.nii.gz"\
    mean "results/sub-${subject}/anat/sub-${subject}_space-acpc_T1w.nii.gz"

echo "Dividing T1w by T2w"
fslmaths "results/sub-${subject}/anat/sub-${subject}_space-acpc_T1w.nii.gz" -div \
    "data/sub-${subject}/anat/sub-${subject}_space-acpc_T2w.nii.gz" \
    "results/sub-${subject}/anat/sub-${subject}_space-acpc_T1divT2.nii.gz"


echo "Getting average T1/T2 for each ROI"
python get_roi_average.py \
    "results/sub-${subject}/anat/sub-${subject}_space-acpc_T1divT2.nii.gz" \
    "data/sub-${subject}/anat/sub-${subject}_space-acpc_desc-aparcaseg_atlas-dk_dparc.nii.gz" \
    "results/sub-${subject}/anat/sub-${subject}_atlas-dkt_desc-mean_T1divT2.tsv"