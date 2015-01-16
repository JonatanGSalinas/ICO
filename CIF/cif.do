**************************************************
*     Import CIF								                 *
**************************************************
* Last update: 2015-01-13 (JN) Add $ROOTDIR  
* CIF.dta contains data about ICO payments by Municipio


clear all
set more off

import excel $ROOTDIR\CIF\CIF.xlsx, sheet("Sheet 1") firstrow

drop if CICLO_FFPP == "CICLO2-CCAA" //We do not use CCAA data, only municipal payments

sort NOMBRE_ENTIDAD
//Robledo is a town in Albace. El Robledo is a town in Ciudad Real. We need to distinguish them
replace NOMBRE_ENTIDAD = "ROBLEDO, EL" if NOMBRE_ENTIDAD == "ROBLEDO (EL)"
replace NOMBRE_ENTIDAD = "ROBLEDO, EL" if NOMBRE_ENTIDAD == "ROBLEDO (EL) (Ciudad Real)"

split NOMBRE_ENTIDAD, parse(" (") //Deleting brackets in Municipio name
drop NOMBRE_ENTIDAD NOMBRE_ENTIDAD2 NOMBRE_ENTIDAD3
//Add up payments by municipio
collapse (sum) IMPORTE_TOTAL_FACTURAS=IMPORTE_FACTURAS NUMERO_TOTAL_FACTURAS=NUMERO_FACTURAS IMPORTE_TOTAL_EMBARGOS=IMPORTE_EMBARGOS, by(NOMBRE_ENTIDAD1 CCAA_ENTIDAD)

//Deleting accents
replace NOMBRE_ENTIDAD1=subinstr(NOMBRE_ENTIDAD1,"Á","A",.)
replace NOMBRE_ENTIDAD1=subinstr(NOMBRE_ENTIDAD1,"É","E",.)
replace NOMBRE_ENTIDAD1=subinstr(NOMBRE_ENTIDAD1,"Í","I",.)
replace NOMBRE_ENTIDAD1=subinstr(NOMBRE_ENTIDAD1,"Ó","O",.)
replace NOMBRE_ENTIDAD1=subinstr(NOMBRE_ENTIDAD1,"Ú","U",.)
replace NOMBRE_ENTIDAD1=subinstr(NOMBRE_ENTIDAD1,"À","A",.)
replace NOMBRE_ENTIDAD1=subinstr(NOMBRE_ENTIDAD1,"È","E",.)
replace NOMBRE_ENTIDAD1=subinstr(NOMBRE_ENTIDAD1,"Ì","I",.)
replace NOMBRE_ENTIDAD1=subinstr(NOMBRE_ENTIDAD1,"Ò","O",.)
replace NOMBRE_ENTIDAD1=subinstr(NOMBRE_ENTIDAD1,"Ù","U",.)

rename NOMBRE_ENTIDAD1 NOMBRE_ENTIDAD
rename CCAA_ENTIDAD CCAA
save $ROOTDIR\CIF\CifAgrupadas.dta, replace
