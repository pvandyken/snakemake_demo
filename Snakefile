configfile: "config/config.yaml"

rule all:
    input:
        expand(
           "results/sub-{subject}/anat/sub-{subject}_atlas-dkt_desc-{stat}_T1divT2.tsv",
           subject=config["subject"],
           stat=config["stat"],
        )

rule average_t1_runs:
    input:
        expand(
            "data/sub-{subject}/anat/sub-{subject}_run-{run}_space-acpc_T1w.nii.gz",
            run=config["runs"],
            allow_missing=True,
        )
    output:
        "results/sub-{subject}/anat/sub-{subject}_space-acpc_T1w.nii.gz",
    shell:
        """
        mrmath {input} mean {output}
        """

rule get_t1_over_t2:
    input:
        t1="results/sub-{subject}/anat/sub-{subject}_space-acpc_T1w.nii.gz",
        t2="data/sub-{subject}/anat/sub-{subject}_space-acpc_T2w.nii.gz",
    output:
        "results/sub-{subject}/anat/sub-{subject}_space-acpc_T1divT2.nii.gz"
    shell:
        """
        fslmaths {input.t1} -div {input.t2} {output}
        """

rule get_roi_average:
    input:
        t1divt2="results/sub-{subject}/anat/sub-{subject}_space-acpc_T1divT2.nii.gz",
        parcellation="data/sub-{subject}/anat/sub-{subject}_space-acpc_desc-aparcaseg_atlas-dk_dparc.nii.gz",
    output:
        "results/sub-{subject}/anat/sub-{subject}_atlas-dkt_desc-{stat}_T1divT2.tsv"
    params:
        stat=lambda wildcards: wildcards["stat"]
    script:
        "get_roi_average.py"


