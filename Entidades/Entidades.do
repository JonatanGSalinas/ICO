************************************
*     Import ICO Data 			   *
************************************
* Last update: 2015-01-13 (JN) ADD $ROOTDIR
* EntidadesMatch.dta contains ICO data and population, unemployment and income data about municipios


clear all
set more off

use $ROOTDIR\Entidades\FFPP_NO_CIFs_complete.dta



drop if ciclo_ffpp == "CICLO2-CCAA" //We do not want CCAA data

//Converting string data into numeric data
replace importe_facturas = subinstr(importe_facturas, ",", ".",.) 
replace numero_facturas = subinstr(numero_facturas, ",", ".",.) 
replace importe_embargos = subinstr(importe_embargos, ",", ".",.) 
destring importe_facturas numero_facturas importe_embargos, replace

//Grouping data by firm´s zip code
collapse (sum)importe_facturas (sum) numero_facturas (sum) importe_embargos, by (codigopostaldomicilio)
rename codigopostaldomicilio CPOST

drop if CPOST==""
save  $ROOTDIR\Entidades\Entidades.dta, replace

//Merging with zip code data in order to match firm-zip code-municipio
merge 1:m CPOST using "$ROOTDIR\Entidades\Postales.dta"
drop if _merge==2
drop _merge

gen Codigo = CPRO + CMUN //Creating INE code: Province Code + Municipio Code
tostring Codigo, replace //INE code to string in order to create panel time serie data

//Grouping data by Municipio
collapse (sum)importe_facturas (sum) numero_facturas (sum) importe_embargos, by (Codigo)
save  $ROOTDIR\Entidades\EntidadesAgrupadas.dta, replace

//Merging with population data
merge 1:1 Codigo using "$ROOTDIR\Demografia\TotalyHombres16a65.dta"
drop if _merge==1
drop _merge

//Creating again Province and Municipio codes to future matchings
gen CPRO = substr(Codigo,1,2)
gen CMUN = substr(Codigo,3,3)

//Merging with debts data
merge 1:1 CPRO CMUN using $ROOTDIR\Deuda\Deuda.dta 
drop _merge

//Merging with income data
merge 1:m Codigo using $ROOTDIR\Presupuestos\Ingresos.dta 
drop if Fecha!="2012" && _merge==3 //We only want 2012 data (liquidity shock year)
drop Fecha //We dont need Fecha anymore
drop _merge

save "$ROOTDIR\Entidades\EntidadesDiff.dta", replace

//Merging with unemployment data
merge 1:m CPRO CMUN using "$ROOTDIR\TablasUnidas\ParoMatch.dta"
drop _merge


//Replacing missing data: we assume that no unemployment data means zero (small and aging towns with no unemployment).
replace Total = 0 if Total == .
replace H25 = 0 if H25 == .
replace H45 = 0 if H45 == .
replace H2544 = 0 if H2544 == .
replace M25 = 0 if M25 == .
replace M45 = 0 if M45 == .
replace M2544 = 0 if M2544 == .
replace Agricultura = 0 if Agricultura == .
replace Industria = 0 if Industria == .
replace Construccion = 0 if Construccion == .
replace Servicios = 0 if Servicios == .
replace NoEmpleoAnterior = 0 if NoEmpleoAnterior == .
replace importe_facturas = 0 if importe_facturas == .



// Shock per capita: ICO liquidity shock / Population
gen ShockPob = importe_facturas/Pob
//Unemployment 
gen ParoH = H25 + H2544 + H45
gen TasaParoH = Paro*100/Hombres16a65



gen DeudaDivPob = ImpDeudViva/Pob  //Ratio: muncicipio debts per capita

replace ShockPob = 0 if ShockPob == .
drop if Fecha == .
drop if Codigo == ""



destring Totalingresos, replace
drop if Totalingresos == 0
drop if Totalingresos == .
gen ShockIng = importe_facturas/Totalingresos //Liquidity shock as an income ratio 


save "$ROOTDIR\Entidades\EntidadesMatch.dta", replace
