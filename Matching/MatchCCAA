***************************************************
*     Matching CCAA and Matching.dta 		      *
***************************************************
* Last update: 2015-01-13 (JN) Add $ROOTDIR 
* Matching.dta contains data about INE code and municipios 

use $ROOTDIR\Matching\Matching.dta
// Combine each province with its ccaa
merge m:1 CPRO using $ROOTDIR\Matching\CCAA.dta 
drop _merge
drop Provincias
save $ROOTDIR\Matching\Matching.dta, replace
