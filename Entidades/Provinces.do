************************************
*     Collapsing by Provinces 	   *
************************************
* Last update: 2015-01-15 (JN) 

clear all
set more off

use "$ROOTDIR\Entidades\EntidadesDiff.dta", clear

//Merging with 
merge m:1 CPRO using "$ROOTDIR\Matching\CCAA.dta"
drop _merge

save "$ROOTDIR\Entidades\EntidadesDiff.dta", replace
 
drop if Codigo!="01059" & Codigo!="02003" & Codigo!="03014" & Codigo!="04013" & Codigo!="05019" & Codigo!="06015" & Codigo!="07040" & Codigo!="08019" & Codigo!="09059" & Codigo!="10037" ///
& Codigo!="11012" & Codigo!="12040" & Codigo!="13034" & Codigo!="14021" & Codigo!="15030" & Codigo!="16078" & Codigo!="17079" & Codigo!="18087" & Codigo!="19130" & Codigo!="20069" & Codigo!="21041" ///
& Codigo!="22125" & Codigo!="23050" & Codigo!="24089" & Codigo!="25120" & Codigo!="26089" & Codigo!="27028" & Codigo!="28079" & Codigo!="29067" & Codigo!="30030" & Codigo!="31201" & Codigo!="32054" ///
& Codigo!="33044" & Codigo!="34120" & Codigo!="35016" & Codigo!="36038" & Codigo!="37274" & Codigo!="38038" & Codigo!="39075" & Codigo!="40194" & Codigo!="41091" & Codigo!="42173" & Codigo!="43148" ///
& Codigo!="44216" & Codigo!="45168" & Codigo!="46250" & Codigo!="47186" & Codigo!="48020" & Codigo!="49275" & Codigo!="50297" & Codigo!="51001" & Codigo!="52001"

gen ShockLiq = importe_facturas/Pob

save "$ROOTDIR\Entidades\EntidadesCapProv.dta", replace

use "$ROOTDIR\Entidades\EntidadesDiff.dta", clear



collapse  (sum)importe_facturas (sum) numero_facturas (sum) importe_embargos, by (CPRO)

//Merging with 
merge 1:1 CPRO using "$ROOTDIR\Matching\CCAA.dta"
drop _merge

save "$ROOTDIR\Entidades\EntidadesProv.dta", replace
