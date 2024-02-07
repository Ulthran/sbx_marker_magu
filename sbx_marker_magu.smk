try:
    BENCHMARK_FP
except NameError:
    BENCHMARK_FP = output_subdir(Cfg, "benchmarks")
try:
    LOG_FP
except NameError:
    LOG_FP = output_subdir(Cfg, "logs")
try:
    VIRUS_FP
except NameError:
    VIRUS_FP = Cfg["all"]["output_fp"] / "virus"


localrules:
    all_marker_magu,


rule all_marker_magu:
    input:
        expand(
            VIRUS_FP / "marker_magu" / "{sample}_{rp}.detected_species.tsv",
            sample=Samples.keys(),
            rp=Pairs,
        ),


rule install_marker_magu:
    output:
        fna=Cfg["sbx_marker_magu"]["db_fp"] / "v1.1" / "Marker-MAGu_markerDB.fna",
        metadata=Cfg["sbx_marker_magu"]["db_fp"]
        / "v1.1"
        / "Marker-MAGu_virus_DB_v1.1_metadata.tsv",
    log:
        LOG_FP / "install_marker_magu.log",
    benchmark:
        BENCHMARK_FP / "install_marker_magu.tsv"
    params:
        base_dir=Cfg["sbx_marker_magu"]["db_fp"],
    shell:
        """
        mkdir -p {params.base_dir}
        cd {params.base_dir}

        if [ ! -f {output.fna} ]; then
            wget https://zenodo.org/records/8342581/files/Marker-MAGu_markerDB_v1.1.tar.gz 2> {log}

            if [[ $(md5sum Marker-MAGu_markerDB_v1.1.tar.gz) == *"e0947cb1d4a3df09829e98627021e0dd"* ]]; then
                tar -xzf Marker-MAGu_markerDB_v1.1.tar.gz
                rm Marker-MAGu_markerDB_v1.1.tar.gz
            else
                echo "ERROR: Marker-MAGu_markerDB_v1.1.tar.gz md5sum does not match"
                exit 1
            fi
        else
            echo "Marker-MAGu database already installed"
        fi
        """


rule run_marker_magu:
    input:
        reads=QC_FP / "decontam" / "{sample}_{rp}.fastq.gz",
        fnas=Cfg["sbx_marker_magu"]["db_fp"] / "v1.1" / "Marker-MAGu_markerDB.fna",
        metadata=Cfg["sbx_marker_magu"]["db_fp"]
        / "v1.1"
        / "Marker-MAGu_virus_DB_v1.1_metadata.tsv",
    output:
        unzipped=temp(QC_FP / "decontam" / "{sample}_{rp}.fastq"),
        detected_species=VIRUS_FP / "marker_magu" / "{sample}_{rp}.detected_species.tsv",
    log:
        LOG_FP / "run_marker_magu_{sample}_{rp}.log",
    benchmark:
        BENCHMARK_FP / "run_marker_magu_{sample}_{rp}.tsv"
    params:
        db_fp=Cfg["sbx_marker_magu"]["db_fp"] / "v1.1",
        out_fp=VIRUS_FP / "marker_magu",
    threads: 8
    resources:
        mem_mb=70000,
        runtime=120,
    conda:
        "envs/sbx_marker_magu_env.yml"
    shell:
        """
        gzip -dkf {input.reads} > {output.unzipped}
        markermagu -r {output.unzipped} -s {wildcards.sample}_{wildcards.rp} -o {params.out_fp} --db {params.db_fp} -t {threads} 2> {log}
        """
