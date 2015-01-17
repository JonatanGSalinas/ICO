************************************
*     Merge CIF and Municipios Data*
************************************
* Last update: 2015-01-13 (JN) Add $ROOTDIR
* Matching ICO data with unemployment,debts, bugets data 



clear


//Matching ICO data with debts data
use $ROOTDIR\TablasUnidas\CifAgrupadasINE.dta
merge 1:1 CPRO CMUN using $ROOTDIR\Deuda\Deuda.dta 
drop _merge

gen Codigo = CPRO + CMUN //INE code

//Matching ICO data with population data
merge 1:1 Codigo using $ROOTDIR\Demografia\TotalyHombres16a65.dta
drop _merge

//Matching ICO data with incomes data
merge 1:m Codigo using $ROOTDIR\Presupuestos\Ingresos.dta 
drop if Fecha!="2012" && _merge==3 //We only want 2012 data (liquidity shock year)
drop Fecha //We dont need Fecha anymore
drop _merge

//Matching ICO data with unemployment data
merge 1:m CPRO CMUN using $ROOTDIR\TablasUnidas\ParoMatch.dta
drop _merge


gen DeudaDivPob = ImpDeudViva/Pob //Ratio: muncicipio debts per capita
gen ParoH = H25 + H2544 + H45 // Unemployment rate
gen TasaParoH = ParoH*100/Hombres16a65

gen ShockPob = IMPORTE_TOTAL_FACTURAS/Pob // Shock per capita: ICO liquidity shock / Population

gen Dummyshock = (Fecha>630) //Dummy: 1 after liquidity shock
							//  0 before liquidity shock


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
replace IMPORTE_TOTAL_FACTURAS = 0 if IMPORTE_TOTAL_FACTURAS == . 

tostring Codigo, replace //INE Code: string in order to create a panel time serie.
drop if Fecha == .
drop if Codigo == ""


destring Totalingresos, replace
drop if Totalingresos == 0 //Preguntar Rolf!!
drop if Totalingresos == .
gen ShockIng = IMPORTE_TOTAL_FACTURA/Totalingresos //Liquidity shock as an income ratio 


save $ROOTDIR\TablasUnidas\CIFParoDeudaMatch.dta, replace
