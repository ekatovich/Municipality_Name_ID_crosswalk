# Municipality_Name_ID_crosswalk
Stata do-file that attaches municipality names to municipality/microregion/mesoregion/uf IBGE identifier codes

Anyone who works with municipality-level data in Brazil has likely encountered the problem
of merging some datasets that only have municipality name-string identifiers with other
datasets that only have 6 or 7-digit numeric code identifiers. Furthermore, merging on name
alone is never good practice, since frequent variations in the spelling of municipality names, 
as well as spelling errors and multiple names for some municipalities cause frequent merging 
errors. 

This Stata do-file resolves these problems by creating a crosswalk between municipality 
name-string identifiers and numeric ID codes for municipalities, microregions, mesoregions,
and ufs (states). It uses open access data on geographical units provided by IBGE:
https://www.ibge.gov.br/explica/codigos-dos-municipios.php

This do-file cleans geographical unit identifiers (municipality, 
microregion, mesoregion, and uf) provided by IBGE, corrects naming ambiguities, 
and saves a cleaned municipality name-id crosswalk file. It then cleans and 
corrects municipality names in your dataset using the same cleaning steps
and merges your dataset with the name-code crosswalk in order to attach 
numeric geographical identifiers to your municipality names.

Note that these codes reflect Brazilian municipalities as recorded by IBGE 
in 2020. There are 5570 municipalities in the sample. To account for municipality
name changes, emancipations, splits etc. in previous years, please refer to
the Minimum Comparable Area (AMC) crosswalk created by Philipp Ehrl:
https://sites.google.com/site/philippehrl/research

I would be happy to hear about any suggestions you might have on how to improve 
this crosswalk. Please consider citing or acknowledging this script if it proves 
useful to your research. 
