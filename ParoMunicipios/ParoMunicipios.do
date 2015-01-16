Enter file contents here************************************
*     Import Unemployment		   *
************************************
* Last update: 2015-01-05 (JN) Add comments 

local loc JN

if "`loc'" == "JN" {
	global data_out "C:\Users\jgarcias\Desktop\Research\ICO"
	global output "C:\Users\jgarcias\Desktop\Research\ICO"
	global data "C:\Users\jgarcias\Desktop\Research\ICO"
	}
clear
set more off
save "$data_out\ParoMunicipios\ParoMunicipios.dta",emptyok replace 
global Provincias `" "ALAVA" "ALICANTE" "ALMERIA" "AVILA" "BADAJOZ" "BALEARES" "BARCELONA" "BURGOS" "CACERES" "CADIZ" "CASTELLON" "CIUDAD REAL" "CORDOBA" "A CORUÑA" "CUENCA" "GIRONA" "GRANADA" "GUADALAJARA" "GIPUZCOA" "HUELVA" "HUESCA" "JAEN" "LEON" "LLEIDA" "LA RIOJA" "LUGO" "MADRID" "MALAGA" "MURCIA" "ALBACETE" "NAVARRA" "OURENSE" "ASTURIAS" "PALENCIA" "LAS PALMAS" "PONTEVEDRA" "SALAMANCA" "STA CRUZ TENER." "CANTABRIA" "SEGOVIA" "SEVILLA" "SORIA" "TARRAGONA" "TERUEL" "TOLEDO" "VALENCIA" "VALLADOLID" "BIZKAIA" "ZAMORA" "ZARAGOZA" "CEUTA" "MELILLA""'
global fechas "2006 2007 2008 2009 2010 2011 2012 2013"
global meses "1 2 3 4 5 6 7 8 9 10 11 12"
global meses2005 "5 6 7 8 9 10 11 12"
global meses2014 "1 2 3 4 5 6 7 8 9"
scalar FechaTemp = tm(2005m5)
scalar t = 0

	foreach mes2005 of global meses2005{
		foreach provincia of global Provincias{
			import excel "$data\ParoMunicipios\2005\\`mes2005'2005.xls", sheet("PARO `provincia'") allstring clear 
			drop if B==""
			drop if _n == _N
			gen Fecha = FechaTemp+t
			gen Provincia = "`provincia'"
			append using "$data_out\ParoMunicipios\ParoMunicipios.dta"
			save "$data_out\ParoMunicipios\ParoMunicipios.dta", replace 
		}
	scalar t=t+1
	}


foreach fecha of global fechas {
	foreach mes of global meses{
		foreach provincia of global Provincias{
			import excel "$data\ParoMunicipios\\`fecha'\\`mes'`fecha'.xls", sheet("PARO `provincia'") allstring clear 
			drop if B==""
			drop if _n == _N
			gen Fecha = FechaTemp+t
			gen Provincia = "`provincia'"
			append using "$data_out\ParoMunicipios\ParoMunicipios.dta"
			save "$data_out\ParoMunicipios\ParoMunicipios.dta", replace 
		}
	scalar t=t+1
	}
}
	foreach mes2014 of global meses2014{
		foreach provincia of global Provincias{
			import excel "$data\ParoMunicipios\2014\\`mes2014'2014.xls", sheet("PARO `provincia'") allstring clear 
			drop if B==""
			drop if _n == _N
			gen Fecha = FechaTemp+t
			gen Provincia = "`provincia'"
			append using "$data_out\ParoMunicipios\ParoMunicipios.dta"
			save "$data_out\ParoMunicipios\ParoMunicipios.dta", replace 
		}
	scalar t=t+1
	}
	
drop A O P
rename B Municipio
rename C Total
rename D H25
rename E H2544
rename F H45
rename G M25
rename H M2544
rename I M45
rename J Agricultura
rename K Industria
rename L Construccion  
rename M Servicios
rename N NoEmpleoAnterior

replace Municipio = "ELBURGO/BURGELU" if Municipio ==  "ELBURGO/BURGUELU"
replace Municipio = "LABASTIDA/BASTIDA" if Municipio ==  "LABASTIDA"
replace Municipio = "LANCIEGO/LANTZIEGO" if Municipio ==  "LANCIEGO/LANFZIEGO"
replace Municipio = "LAUDIO/LLODIO" if Municipio ==  "LLODIO"
replace Municipio = "OYON/OION" if Municipio ==  "OYON-OION"
replace Municipio = "YECORA/IEKORA" if Municipio ==  "YECORA/LEKORA"

replace Municipio = "HONDON DE LAS NIEVES/FONDO DE LES NEUS" if Municipio ==  "HONDON DE LAS NIEVES"
replace Municipio = "HONDON DE LAS NIEVES/FONDO DE LES NEUS" if Municipio ==  "HONDÓN DE LAS NIEVES/FONDÓ DE LES NEUS,E"
replace Municipio = "JALON/XALO" if Municipio ==  "JALON/XALÓ"
replace Municipio = "PINOSO/PINOS, EL" if Municipio ==  "PINOSO"
replace Municipio = "PINOSO/PINOS, EL" if Municipio ==  "PINOSO/PINÓS, EL"
replace Municipio = "SAN VICENTE DEL RASPEIG/SANT VICENT DEL RASPEIG" if Municipio ==  "SAN VICENTE DEL RASPEIG/SANT VICENT DEL"

replace Municipio = "SANCTI-SPIRITUS" if Municipio == "SANCTI-SPIRITUS."
replace Municipio = "ZARZA, LA" if Municipio == "ZARZA, LA."



save "$data_out\ParoMunicipios\ParoMunicipios.dta", replace 
