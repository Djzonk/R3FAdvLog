<p align="center">
    <img src="https://github.com/Djzonk/R3FAdvLog/raw/master//extras/logo/advLog.png">
</p>

<p align="center">
    <a href="https://github.com/stcrowe/R3FAdvLog">
        <img src="https://img.shields.io/badge/Version-1.0.0-brightgreen.svg?style=plastic" alt="Version">
    </a>
    <a href="https://github.com/stcrowe/R3FAdvLog/issues">
        <img src="https://img.shields.io/github/issues-raw/Djzonk/R3FAdvLog.svg?style=plastic&label=Issues" alt="Issues">
    </a>
    <a href="https://forums.bistudio.com/topic/194233-r3f-advance-logistics-unofficial-ace3-beta/">
        <img src="https://img.shields.io/badge/Forum-Thread-3dcfed.svg?style=plastic" alt="BI Forum">
    </a>
    <a href="https://github.com/stcrowe/R3FAdvLog/blob/master/LICENSE">
        <img src="https://img.shields.io/badge/License-GPLv3-blue.svg?style=plastic" alt="license">
    </a>
</p>
    
<p align="center">
    <sup><strong>Requires the latest version of <a href="https://github.com/CBATeam/CBA_A3/releases">CBA A3</a> and <a href="https://github.com/acemod/ACE3/releases">ACE3</a>.<br/></strong></sup>
</p>

# R3F Advance Logistics

### Development Environment

See the [ACE3 documentation](http://ace3mod.com/wiki/development/setting-up-the-development-environment.html) on setting up your development environment.

### Tooling

Once that is all done, run the `setup.py` tool found in the tools directory of your project. This will create the necessary links between your Arma installation, your P Drive and your project source directory.

You can use `build.py` to pack your PBOs for use during development and use `make.py` to create binarized PBOs for release.

#### Releasing a binarized build

You can use make to manage versioning and packing up your release version.

Fresh build and package it up for a release:
```bash
tools/make force checkexternal release 1.0.0
```

Build just a binarized version:
```bash
tools/make
```

### Versioning

You can also manage versioning through the make tool. To do this, navigate to the `addons/main` directory. In there, is a file called `script_mod.hpp`. This contains the following:

```sqf
#define MAJOR 1
#define MINOR 0
#define PATCHLVL 0
#define BUILD 0
```

Modify the numbers in here to represent your build version. The example listed above would be: `1.0.0.0`. This version will be set in each pbo during binarizing. It will also be used in the signature file names, along the commit hash. This will make it easier to identify the exact version that is being used.


### Using CI

This template comes with some basic scripts to validate and enforce parts of the ACE3 coding guidelines. You can find those scripts in the tools directory.

- sqf_validator.py - checks all .sqf files in the addons directory and checks for missing brackets, missing semi-colons and tab usage.
- config_style_checker.py - checks all .hpp and .cpp files in the addons directory and checks for missing brackets and tabs.

For more information on the guidelines, see ACE3 coding guidelines.

You can use these scripts in combination with CI - if you are on GitHub and use Travis-CI, here is an example:

```yml
language: python
python:
- '3.4'
script:
- python3 tools/sqf_validator.py
- python3 tools/config_style_checker.py
```
