************************************
*     Import population data       *
************************************
* Last update: 2015-01-13 (JN) Add $ROOTDIR
* Data downloaded from http://www.ine.es/jaxi/menu.do?type=pcaxis&file=pcaxis&path=%2Ft20%2Fe245%2Fp05%2F%2Fa2013: Padrón Continuo 1 enero del 2013
* You need to use PC-AXIS (awful and obsolete software used by the INE) to view the data and the copy paste it into excel.
* I have used two excel file: one containing male popoulation and anothre one containing female population. Reason: PC-AXIS only shows you the first 5000 cells and there are 8118 municipios in Spain
* so I need to copy paste date several times
* The excel files also contain the Adultos column which is total working age population (16 to 65 years old) 
* Demografia.dta contains data about municipios population by sex and age and working age population


clear
set more off

//Importing male population
save "$ROOTDIR\Demografia\Demografia.dta", emptyok replace
import excel "$ROOTDIR\Demografia\Hombres.xlsx",  firstrow allstring
gen gender = "H" //Set male gender
save "$ROOTDIR\Demografia\Demografia.dta", replace 

//Importing female population
clear
import excel "$ROOTDIR\Demografia\Mujeres.xlsx", firstrow allstring
gen gender = "M" //Set female population
append using "$ROOTDIR\Demografia\Demografia.dta"
save "$ROOTDIR\Demografia\Demografia.dta", replace 

//Creating a variable which contains the INE code for each municipio
split Municipio, parse("-")
drop Municipio2 Municipio3 Municipio4
rename Municipio1 Codigo
drop if Codigo == ""

**Converting to integer variablos containing population ages (E0: 0-years old population, E1: 1-year old population... E100M: 100+years old population"
**Total: E0 + E1 + ... + E100M
**Adultos: E16 + E17 + ... + E65. Population between 16-65 years old. 
destring E0	E1	E2	E3	E4	E5	E6	E7	E8	E9	E10	E11	E12	E13	E14	E15	E16	E17	E18	E19	E20	E21	E22	E23	E24	E25	E26	E27	E28	E29	E30	E31	E32	E33	E34	E35	E36	E37	E38	E39	E40	E41	E42	E43	E44	E45	E46	E47	E48	E49	E50	E51	E52	E53	E54	E55	E56	E57	E58	E59	E60	E61	E62	E63	E64	E65	E66	E67	E68	E69	E70	E71	E72	E73	E74	E75	E76	E77	E78	E79	E80	E81	E82	E83	E84	E85	E86	E87	E88	E89	E90	E91	E92	E93	E94	E95	E96	E97	E98	E99	E100M Total Adultos, replace
save "$ROOTDIR\Demografia\Demografia.dta", replace 
