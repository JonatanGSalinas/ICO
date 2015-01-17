************************************
*     Zip code data				   *
************************************
* Last update: 2015-01-13 (JN) Add $ROOTDIR 
* Postales.dta contains data about zip codes and INE codes 


clear
//import zip code data from INE (http://www.ine.es/ss/Satellite?L=es_ES&c=Page&cid=1254735624326&p=1254735624326&pagename=ProductosYServicios%2FPYSLayout)
import delimited $ROOTDIR\Entidades\TRAMOS-NAL.txt, delimiter(";") varnames(nonames) stringcols(1 2 3) clear 
duplicates drop
rename v1 CPRO
rename v2 CMUN
rename v3 CPOST

save "$ROOTDIR\Entidades\Postales.dta", emptyok replace
clear
//Importing some zip codes that do not appear in the INE Data because they are industrial zones without population
import excel "$ROOTDIR\Entidades\CPostAdicional.xlsx", sheet("Sheet1") firstrow allstring 
append using "$ROOTDIR\Entidades\Postales.dta"
save "$ROOTDIR\Entidades\Postales.dta", emptyok replace
