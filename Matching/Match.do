***************************************************
*     Import Matching.dta 		    			  *
***************************************************
* Last update: 2015-01-13 (JN) Add $ROOTDIR
* Matching.dta contains data about INE code and municipios 

clear all
set more off

import excel $ROOTDIR\Matching\Matching.xlsx, sheet("Matching") firstrow

drop if Municipio == ""
split Municipio, parse(", ")
rename Municipio1 NOMBRE_ENTIDAD 

//There are some towns with the same name in the same CCAA, we need to distiguish them
replace NOMBRE_ENTIDAD = "POZUELO, EL" if NOMBRE_ENTIDAD == "POZUELO" & Provincia == "CUENCA"
replace NOMBRE_ENTIDAD = "CARRASCALEJO, EL" if NOMBRE_ENTIDAD == "CARRASCALEJO" & Provincia == "BADAJOZ"
replace NOMBRE_ENTIDAD = "RABANOS, LOS" if NOMBRE_ENTIDAD == "RABANOS" & Provincia == "SORIA"
replace NOMBRE_ENTIDAD = "ROBLEDO, EL" if NOMBRE_ENTIDAD == "ROBLEDO" & Provincia == "CIUDAD REAL"
replace NOMBRE_ENTIDAD = "SERRADA, LA" if NOMBRE_ENTIDAD == "SERRADA" & Provincia == "AVILA"
replace NOMBRE_ENTIDAD = "TEJADO, EL" if NOMBRE_ENTIDAD == "TEJADO" & Provincia == "SALAMANCA"
drop Municipio2 Municipio3

save $ROOTDIR\Matching\Matching.dta, replace
