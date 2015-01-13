************************************
*     Import Ayuntamientos debts   *
************************************
* Last update: 2015-01-13 (JN) Add $ROOTDIR 
* Deuda.dta contains data about municipios debts in 2013 

clear all
set more off

//Importing Ayuntamientos data about debts 
import excel "$ROOTDIR\Deuda\Deuda Viva Ayuntamientos 2013_v20140709.xls", firstrow
drop I J K           // Empty and useless data at the excel´s bottom
drop if cdcdad == "" // Empty and useless data

//Renaming variables 
rename cdprov CPRO   //CPRO stands for Código de Provincia
rename cdcorp CMUN   //CMUN stands for Código de Municipio

save "$ROOTDIR\Deuda\Deuda.dta", replace
