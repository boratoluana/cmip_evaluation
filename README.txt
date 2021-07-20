# Borato, L., Fetter Filho, A.F.H., Silva, P.G., Mendez, F.J. Characterization and future projections of the Weather Types over the South Atlantic Ocean. 2021.
# borato.luana@gmail.com

The scripts used in the analysis of the article are divide into two:
- CDO: pre-processing of data
- Matlab: statistical analysis

CDO can be used on Linux and Windows, but for windows it is necessary to use te Cygwin64 Terminal interface.
Tutorials for installation on both operating systems are available at: https://code.mpimet.mpg.de/projects/cdo/wiki/Cdo#Documentation
Where tool usage manuals are also available.

All model data used is available at: 
https://drive.google.com/drive/folders/0AIzI55r6GyqzUk9PVA 
and 
https://esgf-node.llnl.gov/projects/esgf-llnl/

The scripts, in order of execution, contain:
- [CDO1_concatenate_files] - concatenates files from the same model
- [CDO2_regrid_seldate]- interpolates the data in 2x2 resolution and selects the South Atlantic Ocean (SAO) area (0.5°N-71.5°S & 71.5°W-20.5°E) in the period from 1979-02-01 to 2005-12-31
- [grid_require] - contains specifications for CDO2_regrid_seldate
- [MAT1_pslgrad] - Organizes the date for the SAO and calculate de pressure gradient
