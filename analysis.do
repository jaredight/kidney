
global directory "C:\Users\jaredmw2\Downloads\cbp_data"
cd $directory
local txtfiles: dir "$directory" files "*.txt"
foreach file of local txtfiles {
	preserve
	di "`file'"
	import delimited `file', delimiters(",") clear
	keep if strpos(naics, "621512")
	//save `file', replace
	save temp, replace
	restore
	append using temp
}

global years 12 13 15 16 17 18
foreach year of global years {
	local filename = "cbp" + "`year'" + "co.txt"
	cd $directory
	import delimited `filename', delimiters(",") clear
	keep if strpos(naics, "621512")
	keep fipstate fipscty est
	rename est est`year'
	save `year', replace
}

global years 13 15 16 17 18
use 12.dta, clear
foreach year of global years {
	merge 1:1 fipstate fipscty using `year'.dta, nogen
}

foreach x of varlist * {
  replace `x' = 0 if(`x' == .)
}

sort est18
save nfacilities, replace


import delimited "Underlying Cause of Death, 1999-2019 kidney.txt", delimiters(tab) clear
drop cruderate
gen cruderate = deaths/population




cd C:\Users\jaredmw2\Downloads\cbp_data
local txtfiles: dir "`directory'" files "*.txt"
foreach file of local txtfiles {
	preserve
	di "`file'"
	import delimited `file', delimiters(",") clear
	keep if strpos(naics, "621512")
	//gen file = `file'
	//gen year = regexs(0) if(regexm(file, "^([a-zA-Z]+)([0-9][0-9])"))
	save temp, replace
	restore
	append using temp
}

