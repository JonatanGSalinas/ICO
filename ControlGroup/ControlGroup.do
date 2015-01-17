************************************
*     Control Group Creator 	   *
************************************
* Last update: 2015-01-17 (JN) Add comments

clear all
set more off


use "$ROOTDIR\Entidades\EntidadesDiff.dta", clear
drop if Pob>2000 //We want only rural towns


replace importe_facturas=0 if  importe_facturas==.
destring Totalingresos, replace

gen Liq = importe_facturas/Pob //Liquidity Shock

xtile quintiles= Liq if Liq>0, nquantiles(5) //Quintiles
drop if quintiles<5 //We only want the biggest quintile 

sort quintiles                
by quintiles: generate ID = _n  //ID: Idintification Number in order to construct a Control Group 
replace ID =. if quintiles !=5

//We build three different control groups
gen ControlID="" 
gen ControlID2 = ""
gen ControlID3 = ""

sort ID

count if ID!=.

local obs=r(N)

//Min and max for the interval matching 
scalar pmin = 0.8
scalar pmax = 1.20

forvalues i=1/`obs'  {
  gen score = 0 //Score for the arithmetic matching
  gen score2= 1 //Score for the geometric matching
  
  foreach dat in Pob Hombres16a65 ImpDeudViva Totalingresos{ 
	if `dat'[`i'] != 0 { 
		gen `dat'Est = abs((`dat' - `dat'[`i'])/ `dat'[`i']) if quintiles != 5  
	}
	else{
		gen `dat'Est = abs(`dat' - `dat'[`i']) if quintiles != 5
	}
	replace score = score + `dat'Est //Arithmetic score
	replace score2 = score2*(`dat'Est+1) //Geometric socore
	drop `dat'Est
  }	
  //It is a good match if it has the minimun score
  quiet summarize score
  replace ControlID2 = ControlID2+"`i'"+"\" if score == r(min) & quintiles != 5 
  quiet summarize score2
  replace ControlID3 = ControlID3+"`i'"+"\" if score2 == r(min) & quintiles != 5
  
  //Calculating the min/max interval
  scalar p=Pob[`i'] 
  scalar h=Hombres16a65[`i']
  scalar d= ImpDeudViva[`i']
  scalar t=Totalingresos[`i']
  replace ControlID=ControlID+"`i'"+"\" if Pob<=p*pmax & Pob>=p*pmin & Hombres16a65>=h*pmin & Hombres16a65<=h*pmax & ImpDeudViva>=d*pmin & ImpDeudViva<=d*pmax & Totalingresos>=t*pmin & Totalingresos<=t*pmax & quintiles !=5
  drop score
  drop score2
 }


summarize if quintiles==5
summarize if quintiles!=5 & ControlID!=""
summarize if quintiles!=5 & ControlID2!=""
summarize if quintiles!=5 & ControlID3!=""

save "$ROOTDIR\ControlGroup\GruposControl.dta", replace
