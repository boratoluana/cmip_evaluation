# Borato, L., Fetter Filho, A.F.H., Silva, P.G., Mendez, F.J. Characterization and future projections of the Weather Types over the South Atlantic Ocean. 2021.
# borato.luana@gmail.com

The codes used in the analysis of the article are divide into two:
- CDO: pre-processing of data
- Matlab: statistical analysis

CDO can be used on Linux and Windows, but for windows it is necessary to use te Cygwin64 Terminal interface.
Tutorials for installation on both operating systems are available at: https://code.mpimet.mpg.de/projects/cdo/wiki/Cdo#Documentation
Where tool usage manuals are also available.

All model data used is available at: 
https://drive.google.com/drive/folders/0AIzI55r6GyqzUk9PVA 
and 
https://esgf-node.llnl.gov/projects/esgf-llnl/

After downloading the model data, manually organize the files into different directories. 
We recommend, for example: "CMIP5_historical"; "CMIP5_scenarios/CMIP5_RCP26"; "CMIP6_historical"; "CMIP6_scenarios/CMIP6_SSP1" ...

Attention: 
	* Matlab codes are written for the CMIP5 historical period and, where necessary, for RCP26 scenario.
	For other data, like CMIP6 or other scenarios, you will need to change the directory and file name in the code. 
	This is only needed on the input lines of code. 
	
	* At the beginning of each code, the requirements needed to run the code are indicated.

The codes, in order of execution, contain:
- [CDO1_concatenate_files] - concatenates files from the same model (some models are more than one file)
	After concatenating the files, manually rename template files that have only one file (those that have not been concatenated), 
	adding "all_" at the beginning of the file name


- [CDO2_regrid_seldate]- interpolates the data in 2x2 resolution and selects the South Atlantic Ocean (SAO) area 
			(0.5°N-71.5°S & 71.5°W-20.5°E) in the period from 1979-02-01 to 2005-12-31

- [grid_require] - contains specifications for CDO2_regrid_seldate
	*It is not necessary to run this code, but it must be in the same directory as CDO2_regrid_seldate

- [MAT1_pslgrad] - organizes the date for the SAO and calculate de pressure gradient
	Remember: Matlab codes are written for the CMIP5 historical period and, where necessary, for RCP26 scenario.
	
- [MAT2_modelprojections] - projects the data of each climate model on the weather types in the field of EOFs

- [MAT3_proboccorr] - calculates the relative frequency of occurrence of each weather type (WT) according to each climate model

- [MAT3a_proboccorr_scenarios] - the relative frequency of occurrence of each weather type for the different scenarios is divided 
	into short, mid and long-term. So, this code is the same MAT3 but considering the subdivisions

- [MAT3b_proboccorr_reanalysis] - if you want to calculate the relative frequency of occurrence of each weather type based on
	the reanalysis data, you can use this code. But the same "prob_occurr_CFSR" and "prob_occurr_seasonal_CFSR" files, 
	output from that code, are available in the "WT_data" directory

- [MAT4_evalperformance] - calculates the scatter index (SI) and the relative entropy (RE) between the historical frequency of 
	occurrence simulated by the climate models and the historical frequency of occurrence by the reanalysis data
 
- [MAT5_evalseasonalperformance] - calculates the seasonal scatter index (SI) between the historical frequency of occurrence 
	simulated by the climate models and the historical frequency of occurrence by the reanalysis data

- [MAT6_evalinterannualvar] - calculates the standard deviation of scatter index (stdSI) between the historical frequency of 
	occurrence variability (represented by standard deviation of the annual values) simulated by the climate models,
	and the historical frequency of occurrence by the reanalysis data (also represented by standard deviation of the annual values)

- [MAT7_magchanges] - calculates the magnitude of changes in the relative frequencies of occurrence of each weather type, 
	through the SI between the frequency of occurrence of the simulations in the reference period and the projections of the 
	respective climate models. In the case of interannual variability, stdSI is used
	
	Remember: Matlab codes are written for the CMIP5 historical period and, where necessary, for RCP26 scenario.

- [MAT8_projconsistency] - calculates the consistency of future projections. SI values greater than or less than 3x std of the mean 
	of the future projections of the models of each CMIP phase are identified
	
	Attention: this code is written for CMIP5 and CMIP6 scenarios, just be careful to run the correct "read files" section in the code.