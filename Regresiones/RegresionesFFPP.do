************************************
*     Preliminary Regressions      *
************************************
* Last update: 2015-01-13 (JN) Add $ROOTDIR

cap log using "$ROOTDIR\Regresiones\regressions.log", replace
set more off
clear
use "$ROOTDIR\Entidades\EntidadesMatch.dta"

destring Codigo, replace
tsset Codigo Fecha

* Generate seasonal (monthly), CCAA, and time dummies:
gen mes = mod(Fecha, 12) + 1
tab  mes, gen(mes_d)
*drop mes_d12				// no hace falta
tab CCAA, gen(ccaa_d)
tab Fecha, gen(time_d)

rename ShockIng Liq
//replace Liq = Liq/1000		// nicer coefficients

* Generate variables
gen Treat = (Liq > 0.07)
gen Post = 1 if Fecha >= 630 
replace Post = 0 if Fecha < 630
gen RuralDummy = 1 if Pob <= 2000
replace RuralDummy = 0 if Pob > 2000

foreach VAR in Treat Post RuralDummy {
	assert !missing(`VAR') 	// checks that there are no missing values
}



summarize Treat Post RuralDummy Liq

rename TasaParoH U
gen D_U = D.U
gen PostLiq = Post*Liq
gen PostTreat = Post*Treat
gen TreatLiq = Treat*Liq
gen PostLiqTreat = Post*Liq*Treat

summarize TreatLiq PostLiqTreat PostLiq

* Regressions
//regress D_U Post Liq Treat PostLiq PostTreat TreatLiq PostLiqTreat DeudaDivPob RuralDummy Pob
*regress D_U Post Liq PostLiq DeudaDivPob RuralDummy Pob
*regress D_U Post Liq Treat PostTreat DeudaDivPob RuralDummy Pob
foreach Y in D_U U {
	regress `Y' Post Liq Treat PostTreat DeudaDivPob RuralDummy Pob mes_d* ccaa_d*
	display "Time dummies"
	regress `Y' Liq Treat PostTreat DeudaDivPob RuralDummy Pob time_d* ccaa_d*
	display "Rurales"
	regress `Y' Liq Treat PostTreat DeudaDivPob RuralDummy Pob time_d* ccaa_d* if RuralDummy != 1
	display "No Rurales"
	regress `Y' Liq Treat PostTreat DeudaDivPob RuralDummy Pob time_d* ccaa_d* if RuralDummy != 0
	display "Sin 2012"
	regress `Y' Liq Treat PostTreat DeudaDivPob RuralDummy Pob time_d* ccaa_d* if (Fecha < 624 | Fecha > 636) // eliminates 2012m1 through 2013m1
}
log close
