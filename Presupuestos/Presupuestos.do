Enter file contents here************************************
*     Import Ayuntamientos budgets *
************************************
* Last update: 2015-01-13 (JN) Add $ROOTDIR 
* Presupuestos.dta contains data about municipios budgets from 2005 to 2012
* Ingresos.dta contains data about municipios incomes from 2005 to 2012

//List of CCAA and dates of budgets
global CCAA "andalucía aragón asturias baleares canarias cantabria castillalamancha castillayleón cataluña comunidadvalenciana extremadura galicia larioja madrid murcia navarra paísvasco"
global fechas "2005 2006 2007 2008 2009 2010 2011 2012"

clear
set more off

save "$ROOTDIR\Presupuestos\Presupuestos.dta", emptyok replace

//Budget data is in an excel for each CCAA
foreach ccaa of global CCAA {
	//Each excel file contains a sheet for each year data (2005 to 2012)
	foreach fecha of global fechas {
		clear
		import excel "$ROOTDIR\Presupuestos\\`ccaa'.xlsx", sheet("`fecha'") firstrow allstring
		generate Fecha = "`fecha'" //Year of the budget
		append using "$ROOTDIR\Presupuestos\Presupuestos.dta"
		save "$ROOTDIR\Presupuestos\Presupuestos.dta", emptyok replace
		}
	}
	
//Old Code
/*do $data_out\PresupuestosAndalucia.do
do $data_out\PresupuestosAragon.do
do $data_out\PresupuestosAsturias.do
do $data_out\PresupuestosBaleares.do
do $data_out\PresupuestosCanarias.do
do $data_out\PresupuestosCantabria.do
do $data_out\PresupuestosCastillaLeon.do
do $data_out\PresupuestosCastillaMancha.do
do $data_out\PresupuestosCataluña.do
do $data_out\PresupuestosExtremadura.do
do $data_out\PresupuestosGalicia.do
do $data_out\PresupuestosLaRioja.do
do $data_out\PresupuestosMadrid.do
do $data_out\PresupuestosMurcia.do
do $data_out\PresupuestosNavarra.do
do $data_out\PresupuestosPaisVasco.do

clear
save "$data_out\Presupuestos.dta", emptyok replace
append using "$data_out\PresupuestosAndalucia.dta"
append using "$data_out\PresupuestosAragon.dta"
append using "$data_out\PresupuestosAsturias.dta"
append using "$data_out\PresupuestosBaleares.dta"
append using "$data_out\PresupuestosCanarias.dta"
append using "$data_out\PresupuestosCantabria.dta"
append using "$data_out\PresupuestosCastillaLeon.dta"
append using "$data_out\PresupuestosCastillaMancha.dta"
append using "$data_out\PresupuestosCataluña.dta"
append using "$data_out\PresupuestosExtremadura.dta"
append using "$data_out\PresupuestosGalicia.dta"
append using "$data_out\PresupuestosLaRioja.dta"
append using "$data_out\PresupuestosMadrid.dta"
append using "$data_out\PresupuestosMurcia.dta"
append using "$data_out\PresupuestosNavarra"
append using "$data_out\PresupuestosPaisVasco.dta"
save "$data_out\Presupuestos.dta", emptyok replace
*/

//We only want municipios data.
drop if Tip != "A"

//We only need a variable for population data. 
gen Pobla = Pobla2012 +Pobla2011 +Pobla2010 +Pobla2009 +Pobla2008 +Pobla2007 + Pobla2006 + Pobla2005 
drop Pobla2012 Pobla2011 Pobla2010 Pobla2009 Pobla2008 Pobla2007 Pobla2006 Pobla2005 

//In 2010 there was a change in the budget law and some names changed. 
gen TasasPreciosPublicosOtros = Tasaspreciospblicosyotros + Tasasyotrosingresos
drop Tasaspreciospblicosyotros Tasasyotrosingresos

gen GastosBienesServicios = Gastoscorrientesenbienesyse + Gastosenbienesctesyservici
drop  Gastoscorrientesenbienesyse Gastosenbienesctesyservici

gen ActuacionesGeneral = Actuacionesdecarctergeneral + Serviciosdecarctergeneral
drop Actuacionesdecarctergeneral Serviciosdecarctergeneral

gen ProteccionCivilSeguridadCiu = Proteccincivilyseguridadciu + Proteccincivilyseguriadadci 
drop Proteccincivilyseguridadciu  Proteccincivilyseguriadadci 

gen TotalGastos = AI + AF
drop AI AF AJ

//Some zeros are missing in the codes, we need them in order to generate the INE code. 
gen NPr = "0" + Pr
replace Pr = NPr if strlen(Pr) == 1 //If the province code has only one character means that a zero is needed
drop NPr
gen N1Cor = "0" + Cor
gen N2Cor = "00" + Cor
replace Cor = N2Cor if strlen(Cor) == 1 //If the muncipio code has only one character means that two zeros are needed
replace Cor = N1Cor if strlen(Cor) == 2 //If the monicipio code has only one character means that a zero is needed
drop N1Cor N2Cor

gen Codigo = Pr + Cor //Codigo stands by INE code identification. It is the concatenation of Province Code and Municipio Code

save "$ROOTDIR\Presupuestos\Presupuestos.dta", emptyok replace

keep Nombre Fecha Codigo Totalingresos
save "$ROOTDIR\Presupuestos\Ingresos.dta",emptyok replace //We are using incomes data only

