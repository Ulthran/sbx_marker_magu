<img src="https://github.com/sunbeam-labs/sunbeam/blob/stable/docs/images/sunbeam_logo.gif" width=120, height=120 align="left" />

# sbx_marker_magu

<!-- Badges start -->
[![Tests](https://github.com/Ulthran/sbx_marker_magu/actions/workflows/tests.yml/badge.svg)](https://github.com/Ulthran/sbx_marker_magu/actions/workflows/tests.yml)
[![Super-Linter](https://github.com/Ulthran/sbx_marker_magu/actions/workflows/linters.yml/badge.svg)](https://github.com/Ulthran/sbx_marker_magu/actions/workflows/linters.yml)
<!-- Badges end -->

## Introduction

sbx_marker_magu is a [sunbeam](https://github.com/sunbeam-labs/sunbeam) extension for detecting and quantifying phages, bacteria, and archaea in whole genome shotgun reads from human-derived samples. This pipeline uses [Marker-MAGu](https://github.com/cmmr/Marker-MAGu/tree/main).

## Installation

Extension install is as simple as passing the extension's URL on GitHub to `sunbeam extend`:

    sunbeam extend https://github.com/Ulthran/sbx_marker_magu

Any user-modifiable parameters specified in `config.yml` are automatically added on `sunbeam init`. If you're installing an extension in a project where you already have a config file, run the following to add the options for your newly added extension to your config (the `-i` flag means in-place config file modification; remove the `-i` flag to see the new config in stdout):

    sunbeam config update -i /path/to/project/sunbeam_config.yml

Installation instructions for older versions of Sunbeam are included at the end of this README.

## Running

To run an extension, simply run Sunbeam as usual with your extension's target rule specified:

    sunbeam run --profile /path/to/project/ all_marker_magu

### Options for config.yml

  - db_fp: Path to install database to
    
## Installing an extension (legacy instructions for sunbeam <3.0)

Installing an extension is as simple as cloning (or moving) your extension directory into the sunbeam/extensions/ folder, installing requirements through Conda, and adding the new options to your existing configuration file: 

    git clone https://github.com/Ulthran/sbx_marker_magu/ sunbeam/extensions/sbx_marker_magu
    cat sunbeam/extensions/sbx_marker_magu/config.yml >> sunbeam_config.yml

## Issues with pipeline

Please post any issues with this extension [here](https://github.com/Ulthran/sbx_marker_magu/issues).
