/*******************************************************************************
Crosswalk to connect Brazilian municipality name strings to numeric municipality/
microregion/mesoregion/uf IBGE code identifiers

Last Modified: June 3, 2020

By: Erik Katovich

*Description: This do-file cleans geographical unit identifiers (municipality, 
microregion, mesoregion, and uf) provided by IBGE, corrects naming ambiguities, 
and saves a cleaned municipality name-id crosswalk file. It then cleans and 
corrects municipality names in your dataset using the same cleaning steps
and merges your dataset with the name-code crosswalk in order to attach 
numeric geographical identifiers to your municipality names. This operation 
greatly facilitates any merges you wish to do between datasets that only have
municipality name strings as identifiers with municipality-level datasets that
have the 7 or 6 digit code identifiers provided by IBGE. 

It is always a good idea to attach numeric identifiers and merge using these, 
rather than merging using names, since spelling differences and name changes
create frequent merging errors. 

Data source: Municipality names and municipality/microregion/mesoregion/uf 
code identifiers are drawn from open access data on Brazilian geographical 
units provided at: https://www.ibge.gov.br/explica/codigos-dos-municipios.php
Note that these codes reflect Brazilian municipalities as recorded by IBGE 
in 2020. There are 5570 municipalities in the sample. To account for municipality
name changes, emancipations, splits etc. in previous years, please refer to
the Minimum Comparable Area (AMC) crosswalk created by Philipp Ehrl:
https://sites.google.com/site/philippehrl/research
*/

********************************************************************************
/*
HOW TO USE THIS SCRIPT: 
1. ADJUST THE GLOBAL FILE DIRECTORY FOR YOUR COMPUTER
2. DOWNLOAD THE REQUIRED .CSV FILE "Munic_Micro_Meso_Region_Codes.csv" TO THIS FOLDER
3. RUN SECTION 1 OF THIS DO-FILE TO CREATE THE CROSSWALK
4. GO TO SECTION 2 OF THIS DO-FILE 

*/


********************************************************************************
*0. Setup 
********************************************************************************

version 16             // Set Version number for backward compatibility
set more off            // Disable partitioned output
clear all               // Start with a clean slate
set linesize 80         // Line size limit to make output more readable
macro drop _all         // clear all macros

*Adjust user path to match the desired file path on your computer
global user "C:/Users/17637/Documents/GitHub"

	global	name_cleaning			"$user/Municipality_Name_ID_crosswalk"

********************************************************************************
*Set working directory
cd "$name_cleaning"
********************************************************************************

********************************************************************************
*1. Create name-id crosswalk 
********************************************************************************

*Import .csv file containing information on geographical units
import delimited "Munic_Micro_Meso_Region_Codes.csv", clear

rename uf_no UF_NO

*Remove all accents and special characters from munic using ustrnormalize:
		replace munic = ustrto(ustrnormalize(munic, "nfd"), "ascii", 2)	
		*Remove hyphens, apostrophes, and spaces	
		replace munic =subinstr(munic,"-","",.)
		replace munic =subinstr(munic,"'","",.)
		replace munic =subinstr(munic," ","",.)	
		*Convert all letters to uppercase
		replace munic = upper(munic)
		
		*Generate unique municipality-state text identifier
		*Note that adding state (uf) identifiers to the end of municipality
		*name strings is necessary because the same municipality names appear
		*in multiple states. Thus, without state identifiers attached, 
		*it is impossible to achieve a unique name-based merge
		egen municipality = concat(munic UF_NO) 
		drop microregion mesoregion munic 
		
		*Generate 6-digit municipality code identifier 
		*Note that the 6-digit IBGE municipality code is usefule because many
		*Brazilian municipality-level datasets come with only the 6-digit, 
		*rather than full 7-digit identifier. 
		tostring munic_code, replace 
		gen munic_code_6digit = substr(munic_code,1,6)
		destring munic_code, replace
		destring munic_code_6digit, replace
		order municipality munic_code munic_code_6digit UF_NO micro_code meso_code 
			
*Correct common naming variations to improve merging
*These corrections should be run on all datasets prior to merging on "municipality"
*Corrections account for 1) spelling variations, 2) abbreviations, 3) name changes, 4) data entry errors
replace municipality = "BALNEARIOPICARRAS42" if municipality == "PICARRAS42"
replace municipality = "PARATI33" if municipality == "PARATY33"
replace municipality = "TRAJANODEMORAIS33" if municipality == "TRAJANODEMORAES33"
replace municipality = "PRESIDENTECASTELOBRANCO42" if municipality == "PRESIDENTECASTELLOBRANCO42"
replace municipality = "COUTOMAGALHAES17" if municipality == "COUTODEMAGALHAES17"
replace municipality = "MOGIDASCRUZES35" if municipality == "MOJIDASCRUZES35"
replace municipality = "LAGOADOITAENGA26" if municipality == "LAGOADEITAENGA26" 
replace municipality = "BELEMDESAOFRANCISCO26" if municipality == "BELEMDOSAOFRANCISCO26"
replace municipality = "ILHADEITAMARACA26" if municipality == "ITAMARACA26"
replace municipality = "ITABIRINHA31" if municipality == "ITABIRINHADEMANTENA31"
replace municipality = "SAOVALERIO17" if municipality == "SAOVALERIODANATIVIDADE17"
replace municipality = "AROEIRASDOITAIM22" if municipality == "AROEIRASDEITAIM22"
replace municipality = "SAOMIGUELDOGOSTOSO24" if municipality == "SAOMIGUELDETOUROS24"
replace municipality = "SAODOMINGOS25" if municipality == "SAODOMINGOSDEPOMBAL25"
replace municipality = "TACIMA25" if municipality == "CAMPODESANTANA25"
replace municipality = "GOVERNADORLOMANTOJUNIOR29" if municipality == "BARROPRETO29"
replace municipality = "ARMACAODOSBUZIOS33" if municipality == "ARMACAODEBUZIOS33"
replace municipality = "ALTOPARAISO41" if municipality == "VILAALTA41"
replace municipality = "ASSU24" if municipality == "ACU24"
replace municipality = "AGUADOCEDOMARANHAO21" if municipality == "AGUADOCE21"
replace municipality = "ALAGOINHADOPIAUI22" if municipality == "ALAGOINHA22"
replace municipality = "ALMEIRIM15" if municipality == "ALMERIM15"
replace municipality = "AMPARODESAOFRANCISCO28" if municipality == "AMPARODOSAOFRANCISCO28"
replace municipality = "BADYBASSITT35" if municipality == "BADYBASSIT35"
replace municipality = "BALNEARIOBARRADOSUL42" if municipality == "BALNEARIODEBARRADOSUL42"
replace municipality = "BALNEARIOCAMBORIU42" if municipality == "BALNEARIODECAMBORIU42"
replace municipality = "BARAUNA25" if municipality == "BARAUNAS25"
replace municipality = "BELAVISTADOMARANHAO21" if municipality == "BELAVISTA21"
replace municipality = "BERNARDINODECAMPOS35" if municipality == "BERNADINODECAMPOS35"
replace municipality = "CABODESANTOAGOSTINHO26" if municipality == "CABO26"
replace municipality = "CAMPOGRANDE24" if municipality == "AUGUSTOSEVERO24"
replace municipality = "CAMPOSDOSGOYTACAZES33" if municipality == "CAMPOS33"
replace municipality = "CANINDEDESAOFRANCISCO28" if municipality == "CANINDEDOSAOFRANCISCO28"
replace municipality = "CONSELHEIROMAIRINCK41" if municipality == "CONSELHEIROMAYRINCK41"
replace municipality = "DEPUTADOIRAPUANPINHEIRO23" if municipality == "DEPIRAPUANPINHEIRO23"
replace municipality = "DIAMANTEDOESTE41" if municipality == "DIAMANTEDOOESTE41"
replace municipality = "ELDORADODOSCARAJAS15" if municipality == "ELDORADODOCARAJAS15"
replace municipality = "EMBUDASARTES35" if municipality == "EMBU35"
replace municipality = "EUSEBIO23" if municipality == "EUZEBIO23"
replace municipality = "FERNANDOPEDROZA24" if municipality == "FERNANDOPEDROSA24"
replace municipality = "FLORINIA35" if municipality == "FLORINEA35"
replace municipality = "GOVERNADOREDISONLOBAO21" if municipality == "GOVERNADOREDSONLOBAO21"
replace municipality = "GRACHOCARDOSO28" if municipality == "GRACCHOCARDOSO28"
replace municipality = "GRANJEIRO23" if municipality == "GRANGEIRO23"
replace municipality = "HERVALDOESTE42" if municipality == "HERVALDOOESTE42"
replace municipality = "ITAGUAJE41" if municipality == "ITAGUAGE41"
replace municipality = "ITAPEJARADOESTE41" if municipality == "ITAPEJARADOOESTE41"
replace municipality = "JABOATAODOSGUARARAPES26" if municipality == "JABOATAO26"
replace municipality = "LAGEADOGRANDE42" if municipality == "LAGEADOGRANDE42"
replace municipality = "LUIZALVES42" if municipality == "LUISALVES42"
replace municipality = "LUISDOMINGUESDOMARANHAO21" if municipality == "LUISDOMINGUES21"
replace municipality = "LUIZIANIA35" if municipality == "LUISIANIA41"
replace municipality = "MOJIMIRIM35" if municipality == "MOGIMIRIM35"
replace municipality = "MOREIRASALES41" if municipality == "MOREIRASALLES41"
replace municipality = "MUNHOZDEMELO41" if municipality == "MUNHOZDEMELLO41"
replace municipality = "MUQUEMDESAOFRANCISCO29" if municipality == "MUQUEMDOSAOFRANCISCO29"
replace municipality = "PATYDOALFERES33" if municipality == "PATIDOALFERES33"
replace municipality = "QUIJINGUE29" if municipality == "QUINJINGUE29"
replace municipality = "SALMOURAO35" if municipality == "SALMORAO35"
replace municipality = "SANTANADOITARARE41" if municipality == "SANTAANADOITARARE41"
replace municipality = "SANTACRUZDEMONTECASTELO41" if municipality == "SANTACRUZDOMONTECASTELO41"
replace municipality = "SANTAISABELDOIVAI41" if municipality == "SANTAIZABELDOIVAI41"
replace municipality = "SANTAISABELDOPARA15" if municipality == "SANTAIZABELDOPARA15"
replace municipality = "SANTAMARIADEJETIBA32" if municipality == "SANTAMARIADOJETIBA32"
replace municipality = "SANTATERESINHA29" if municipality == "SANTATEREZINHA29"
replace municipality = "SANTOANTONIODEPOSSE35" if municipality == "SANTOANTONIODAPOSSE35"
replace municipality = "SAOCAETANO26" if municipality == "SAOCAITANO26"
replace municipality = "SAODOMINGOSDONORTE32" if municipality == "SAODOMINGOS32"
replace municipality = "SAOJOSEDOCAMPESTRE24" if municipality == "SAOJOSEDECAMPESTRE24"
replace municipality = "SAOJOSEDOBREJODOCRUZ25" if municipality == "SAOJOSEDOBREJOCRUZ25"
replace municipality = "SAOLUIZGONZAGA43" if municipality == "SAOLUISGONZAGA43"
replace municipality = "SAORAIMUNDODODOCABEZERRA21" if municipality == "SAORAIMUNDODADOCABEZERRA21"
replace municipality = "SAOSEBASTIAODELAGOADEROCA25" if municipality == "SAOSEB.DELAGOADEROCA25"
replace municipality = "SAOVICENTEDOSERIDO25" if municipality == "SERIDO25"
replace municipality = "SENADORLAROCQUE21" if municipality == "SENADORLAROQUE21"
replace municipality = "TEOTONIOVILELA27" if municipality == "SENADORTEOTONIOVILELA27"
replace municipality = "SERRACAIADA24" if municipality == "SERRACAIADA24"
replace municipality = "SUDMENNUCCI35" if municipality == "SUDMENUCCI35"
replace municipality = "SUZANAPOLIS35" if municipality == "SUZANOPOLIS35"
replace municipality = "TEJUCUOCA23" if municipality == "TEJUSSUOCA23"
replace municipality = "TRINDADEDOSUL43" if municipality == "TRINDADE43"
replace municipality = "VALPARAISO35" if municipality == "VALPARAIZO35"
replace municipality = "VARRESAI33" if municipality == "VARREESAI33"
replace municipality = "VISEU15" if municipality == "VIZEU15"
replace municipality = "LAJEADOGRANDE42" if municipality == "LAGEADOGRANDE42"
replace municipality = "SENADORCATUNDA23" if municipality == "CATUNDA23"
replace municipality = "LAGOAALEGRE22" if municipality == "LOGOAALEGRE22"

*Save crosswalk file
save "brazil_geographical_codes.dta", replace


********************************************************************************
*2. Import your data, specify cleaning steps, and merge with crosswalk 
********************************************************************************

		*2.1 Now import your file, [YOUR_FILE] that has municipality names but no numeric IDs 
		*[IMPORT HERE]


		*2.2. Rename municipality name variable to "munic":
		*rename [municipality variable name] munic

		*2.3 Remove all accents and special characters from munic using ustrnormalize:
				replace munic = ustrto(ustrnormalize(munic, "nfd"), "ascii", 2)	
				*Remove hyphens, apostrophes, and spaces	
				replace munic =subinstr(munic,"-","",.)
				replace munic =subinstr(munic,"'","",.)
				replace munic =subinstr(munic," ","",.)	
				*Convert all letters to uppercase
				replace munic = upper(munic)


		*2.4 If your dataset has uf number, simply rename this variable UF_NO
		*then skip to 2.6. If your dataset has uf initial or name, skip 2.4 and
		*go to step 2.5
		*rename [uf number variable name] UF_NO

		*2.5 If your dataset has uf initials, run this code:
		*(If you have uf names, first convert them to initials and then run this)
			/*	
				*Generate numeric UF labels
				generate UF_NO = .
				replace UF_NO = 11 if uf == "RO"
				replace UF_NO = 12 if uf == "AC"
				replace UF_NO = 13 if uf == "AM"
				replace UF_NO = 14 if uf == "RR"
				replace UF_NO = 15 if uf == "PA"
				replace UF_NO = 16 if uf == "AP"
				replace UF_NO = 17 if uf == "TO"

				replace UF_NO = 21 if uf == "MA"
				replace UF_NO = 22 if uf == "PI"
				replace UF_NO = 23 if uf == "CE"
				replace UF_NO = 24 if uf == "RN"
				replace UF_NO = 25 if uf == "PB"
				replace UF_NO = 26 if uf == "PE"
				replace UF_NO = 27 if uf == "AL"
				replace UF_NO = 28 if uf == "SE"
				replace UF_NO = 29 if uf == "BA"

				replace UF_NO = 31 if uf == "MG"
				replace UF_NO = 32 if uf == "ES"
				replace UF_NO = 33 if uf == "RJ"
				replace UF_NO = 35 if uf == "SP"

				replace UF_NO = 41 if uf == "PR"
				replace UF_NO = 42 if uf == "SC"
				replace UF_NO = 43 if uf == "RS"

				replace UF_NO = 50 if uf == "MS"
				replace UF_NO = 51 if uf == "MT"
				replace UF_NO = 52 if uf == "GO"
				replace UF_NO = 53 if uf == "DF"
			*/	

				
			*2.6 Generate unique municipality-state text identifier
			egen municipality = concat(munic UF_NO) 
			drop munic 
			order municipality UF_NO 

		
		*2.7 Correct common naming variations to improve merging
		*These corrections should be run on all datasets prior to merging on "municipality"
		*Corrections account for 1) spelling variations, 2) abbreviations, 3) name changes, 4) data entry errors
		replace municipality = "BALNEARIOPICARRAS42" if municipality == "PICARRAS42"
		replace municipality = "PARATI33" if municipality == "PARATY33"
		replace municipality = "TRAJANODEMORAIS33" if municipality == "TRAJANODEMORAES33"
		replace municipality = "PRESIDENTECASTELOBRANCO42" if municipality == "PRESIDENTECASTELLOBRANCO42"
		replace municipality = "COUTOMAGALHAES17" if municipality == "COUTODEMAGALHAES17"
		replace municipality = "MOGIDASCRUZES35" if municipality == "MOJIDASCRUZES35"
		replace municipality = "LAGOADOITAENGA26" if municipality == "LAGOADEITAENGA26" 
		replace municipality = "BELEMDESAOFRANCISCO26" if municipality == "BELEMDOSAOFRANCISCO26"
		replace municipality = "ILHADEITAMARACA26" if municipality == "ITAMARACA26"
		replace municipality = "ITABIRINHA31" if municipality == "ITABIRINHADEMANTENA31"
		replace municipality = "SAOVALERIO17" if municipality == "SAOVALERIODANATIVIDADE17"
		replace municipality = "AROEIRASDOITAIM22" if municipality == "AROEIRASDEITAIM22"
		replace municipality = "SAOMIGUELDOGOSTOSO24" if municipality == "SAOMIGUELDETOUROS24"
		replace municipality = "SAODOMINGOS25" if municipality == "SAODOMINGOSDEPOMBAL25"
		replace municipality = "TACIMA25" if municipality == "CAMPODESANTANA25"
		replace municipality = "GOVERNADORLOMANTOJUNIOR29" if municipality == "BARROPRETO29"
		replace municipality = "ARMACAODOSBUZIOS33" if municipality == "ARMACAODEBUZIOS33"
		replace municipality = "ALTOPARAISO41" if municipality == "VILAALTA41"
		replace municipality = "ASSU24" if municipality == "ACU24"
		replace municipality = "AGUADOCEDOMARANHAO21" if municipality == "AGUADOCE21"
		replace municipality = "ALAGOINHADOPIAUI22" if municipality == "ALAGOINHA22"
		replace municipality = "ALMEIRIM15" if municipality == "ALMERIM15"
		replace municipality = "AMPARODESAOFRANCISCO28" if municipality == "AMPARODOSAOFRANCISCO28"
		replace municipality = "BADYBASSITT35" if municipality == "BADYBASSIT35"
		replace municipality = "BALNEARIOBARRADOSUL42" if municipality == "BALNEARIODEBARRADOSUL42"
		replace municipality = "BALNEARIOCAMBORIU42" if municipality == "BALNEARIODECAMBORIU42"
		replace municipality = "BARAUNA25" if municipality == "BARAUNAS25"
		replace municipality = "BELAVISTADOMARANHAO21" if municipality == "BELAVISTA21"
		replace municipality = "BERNARDINODECAMPOS35" if municipality == "BERNADINODECAMPOS35"
		replace municipality = "CABODESANTOAGOSTINHO26" if municipality == "CABO26"
		replace municipality = "CAMPOGRANDE24" if municipality == "AUGUSTOSEVERO24"
		replace municipality = "CAMPOSDOSGOYTACAZES33" if municipality == "CAMPOS33"
		replace municipality = "CANINDEDESAOFRANCISCO28" if municipality == "CANINDEDOSAOFRANCISCO28"
		replace municipality = "CONSELHEIROMAIRINCK41" if municipality == "CONSELHEIROMAYRINCK41"
		replace municipality = "DEPUTADOIRAPUANPINHEIRO23" if municipality == "DEPIRAPUANPINHEIRO23"
		replace municipality = "DIAMANTEDOESTE41" if municipality == "DIAMANTEDOOESTE41"
		replace municipality = "ELDORADODOSCARAJAS15" if municipality == "ELDORADODOCARAJAS15"
		replace municipality = "EMBUDASARTES35" if municipality == "EMBU35"
		replace municipality = "EUSEBIO23" if municipality == "EUZEBIO23"
		replace municipality = "FERNANDOPEDROZA24" if municipality == "FERNANDOPEDROSA24"
		replace municipality = "FLORINIA35" if municipality == "FLORINEA35"
		replace municipality = "GOVERNADOREDISONLOBAO21" if municipality == "GOVERNADOREDSONLOBAO21"
		replace municipality = "GRACHOCARDOSO28" if municipality == "GRACCHOCARDOSO28"
		replace municipality = "GRANJEIRO23" if municipality == "GRANGEIRO23"
		replace municipality = "HERVALDOESTE42" if municipality == "HERVALDOOESTE42"
		replace municipality = "ITAGUAJE41" if municipality == "ITAGUAGE41"
		replace municipality = "ITAPEJARADOESTE41" if municipality == "ITAPEJARADOOESTE41"
		replace municipality = "JABOATAODOSGUARARAPES26" if municipality == "JABOATAO26"
		replace municipality = "LAGEADOGRANDE42" if municipality == "LAGEADOGRANDE42"
		replace municipality = "LUIZALVES42" if municipality == "LUISALVES42"
		replace municipality = "LUISDOMINGUESDOMARANHAO21" if municipality == "LUISDOMINGUES21"
		replace municipality = "LUIZIANIA35" if municipality == "LUISIANIA41"
		replace municipality = "MOJIMIRIM35" if municipality == "MOGIMIRIM35"
		replace municipality = "MOREIRASALES41" if municipality == "MOREIRASALLES41"
		replace municipality = "MUNHOZDEMELO41" if municipality == "MUNHOZDEMELLO41"
		replace municipality = "MUQUEMDESAOFRANCISCO29" if municipality == "MUQUEMDOSAOFRANCISCO29"
		replace municipality = "PATYDOALFERES33" if municipality == "PATIDOALFERES33"
		replace municipality = "QUIJINGUE29" if municipality == "QUINJINGUE29"
		replace municipality = "SALMOURAO35" if municipality == "SALMORAO35"
		replace municipality = "SANTANADOITARARE41" if municipality == "SANTAANADOITARARE41"
		replace municipality = "SANTACRUZDEMONTECASTELO41" if municipality == "SANTACRUZDOMONTECASTELO41"
		replace municipality = "SANTAISABELDOIVAI41" if municipality == "SANTAIZABELDOIVAI41"
		replace municipality = "SANTAISABELDOPARA15" if municipality == "SANTAIZABELDOPARA15"
		replace municipality = "SANTAMARIADEJETIBA32" if municipality == "SANTAMARIADOJETIBA32"
		replace municipality = "SANTATERESINHA29" if municipality == "SANTATEREZINHA29"
		replace municipality = "SANTOANTONIODEPOSSE35" if municipality == "SANTOANTONIODAPOSSE35"
		replace municipality = "SAOCAETANO26" if municipality == "SAOCAITANO26"
		replace municipality = "SAODOMINGOSDONORTE32" if municipality == "SAODOMINGOS32"
		replace municipality = "SAOJOSEDOCAMPESTRE24" if municipality == "SAOJOSEDECAMPESTRE24"
		replace municipality = "SAOJOSEDOBREJODOCRUZ25" if municipality == "SAOJOSEDOBREJOCRUZ25"
		replace municipality = "SAOLUIZGONZAGA43" if municipality == "SAOLUISGONZAGA43"
		replace municipality = "SAORAIMUNDODODOCABEZERRA21" if municipality == "SAORAIMUNDODADOCABEZERRA21"
		replace municipality = "SAOSEBASTIAODELAGOADEROCA25" if municipality == "SAOSEB.DELAGOADEROCA25"
		replace municipality = "SAOVICENTEDOSERIDO25" if municipality == "SERIDO25"
		replace municipality = "SENADORLAROCQUE21" if municipality == "SENADORLAROQUE21"
		replace municipality = "TEOTONIOVILELA27" if municipality == "SENADORTEOTONIOVILELA27"
		replace municipality = "SERRACAIADA24" if municipality == "SERRACAIADA24"
		replace municipality = "SUDMENNUCCI35" if municipality == "SUDMENUCCI35"
		replace municipality = "SUZANAPOLIS35" if municipality == "SUZANOPOLIS35"
		replace municipality = "TEJUCUOCA23" if municipality == "TEJUSSUOCA23"
		replace municipality = "TRINDADEDOSUL43" if municipality == "TRINDADE43"
		replace municipality = "VALPARAISO35" if municipality == "VALPARAIZO35"
		replace municipality = "VARRESAI33" if municipality == "VARREESAI33"
		replace municipality = "VISEU15" if municipality == "VIZEU15"
		replace municipality = "LAJEADOGRANDE42" if municipality == "LAGEADOGRANDE42"
		replace municipality = "SENADORCATUNDA23" if municipality == "CATUNDA23"
		replace municipality = "LAGOAALEGRE22" if municipality == "LOGOAALEGRE22"


		*2.8 Now merge cleaned names dataset with Brazil geographical units crosswalk 
		merge m:1 municipality using "brazil_geographical_codes.dta"

		*2.9 Inspect merge failures and make name corrections as above to fix them 
		sort _merge
		
		*2.10 Drop _merge to clean up dataset and save final dataset with 
		*numeric geographic identifiers attached to cleaned names
		drop _merge
		
		*Save your dataset with geographical code identifiers
		save "[your crosswalked dataset's name].dta", replace 
		
********************************************************************************

