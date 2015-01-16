*******************************************************
*     Import Election Results Municipales 2007/2011   *
*******************************************************
* Last update: 2015-01-14(JN) Add 2007 results
* EleccionesMunicipales.dta contains data about election results in 2011 by municipios 


clear all
set more off

//Importing Election Results Municipales 2011. First Part
import excel "$ROOTDIR\EleccionesMunicipales\2011PrimeraParte.xlsx", firstrow
save "$ROOTDIR\EleccionesMunicipales\EleccionesMunicipales2011.dta", emptyok replace


//Importing Election Results Municipales 2011. Second Part
clear
import excel "$ROOTDIR\EleccionesMunicipales\2011SegundaParte.xlsx", firstrow
append using "$ROOTDIR\EleccionesMunicipales\EleccionesMunicipales2011.dta"
save "$ROOTDIR\EleccionesMunicipales\EleccionesMunicipales2011.dta", emptyok replace

//Importing Election Results Municipales 2007. First Part
clear
import excel "$ROOTDIR\EleccionesMunicipales\2007PrimeraParte.xlsx", firstrow
save "$ROOTDIR\EleccionesMunicipales\EleccionesMunicipales2007.dta", emptyok replace


//Importing Election Results Municipales 2007. Second Part
clear
import excel "$ROOTDIR\EleccionesMunicipales\2007SegundaParte.xlsx", firstrow
append using "$ROOTDIR\EleccionesMunicipales\EleccionesMunicipales2007.dta"
save "$ROOTDIR\EleccionesMunicipales\EleccionesMunicipales2007.dta", emptyok replace
