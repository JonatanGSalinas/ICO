************************************
*     Merge Paro and Matching	   *
************************************
* Last update: 2015-01-13 (JN) Add $ROOTDIR 
* Adding INE codes to unemplyoment data
* ParoMatch.dta contains data about municipios unemployment(ID: INE code)

use $ROOTDIR\Paro\ParoMunicipios.dta
//Merging with Matching.dta (INE codes)
merge m:1 Municipio Provincia using $ROOTDIR\Matching\Matching.dta 
drop NOMBREINE NOMBREINEUPPER NOMBRE_ENTIDAD _merge
save $ROOTDIR\Paro\ParoMatch.dta, replace
