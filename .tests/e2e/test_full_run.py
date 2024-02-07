import pytest
import shutil
import subprocess as sp
import tempfile
from pathlib import Path


@pytest.fixture
def setup():
    temp_dir = Path(tempfile.mkdtemp())

    reads_fp = Path(".tests/data/reads/").resolve()

    project_dir = temp_dir / "project/"

    sp.check_output(["sunbeam", "init", "--data_fp", reads_fp, project_dir])

    yield temp_dir, project_dir

    shutil.rmtree(temp_dir)


@pytest.fixture
def run_sunbeam(setup):
    temp_dir, project_dir = setup

    # Run the test job dry run
    output = sp.run(
        [
            "sunbeam",
            "run",
            "--profile",
            project_dir,
            "all_marker_magu",
            "--directory",
            temp_dir,
            "-n",
        ],
        shell=True,
        text=True,
        capture_output=True
    )

    assert (
        "all_marker_magu" in output.stdout
    ), f"stdout: {output.stdout}, stderr: {output.stderr}"

    output_fp = project_dir / "sunbeam_output"
    benchmarks_fp = project_dir / "stats/"

    yield output_fp, benchmarks_fp


def test_full_run(run_sunbeam):
    output_fp, benchmarks_fp = run_sunbeam

    # DRY RUN
    # long1_fp = output_fp / "virus" / "marker_magu" / "LONG_1.detected_species.tsv"

    # Check output
    # assert long1_fp.exists(), f"{long1_fp} does not exist"
