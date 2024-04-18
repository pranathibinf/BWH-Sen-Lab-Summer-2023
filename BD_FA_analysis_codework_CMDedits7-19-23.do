*Merging Metadata with Fattyacid Data*
// step1: opening the datasets and merging them with respect to their sampleids
use "C:\Users\limmala.p\Documents\fattyacids.dta"
merge 1:m sampleid using "C:\Users\limmala.p\Documents\ids.dta"
drop if _merge==2
save "C:\Users\limmala.p\Documents\fattyacids.dta" 

// step2: v1 dataset
keep collectiontime == 1

// step3: repeat with fattyacids.dta for v4 dataset
keep collectiontime == 2

// step4: change variable names adding v1 or v4
rename nm_perc8 v1_nm_perc8
rename nm_perc12 v4_nm_perc12
///saved v1 and v2 datasets as v1_samples.dta and v4_samples.dta respectively 

// step5: merge v1 and v4
use  "C:\Users\limmala.p\Documents\v4_samples.dta"
rename v4_nm_perc24_6w3 v4_nm_perc22_6w3 //label for DHA misnamed
*add v4 before every variable*
save "C:\Users\limmala.p\Documents\final run\v4_samples.dta
// repeat the same by adding v1 for v1 dataset and merge them both
use "C:\Users\limmala.p\Documents\v1_samples.dta"
merge 1:m studyid using "C:\Users\limmala.p\Documents\v4_samples.dta"
///saved file as timepoint_merged_final.dta (tp = timepoint)

// step6: merge timepoint_merged_final.dta with Clinical metadata
use "C:\Users\limmala.p\Documents\Projahmno_AMANHI_Limited Data for Pranathi.csv"
merge 1:m studyid using "C:\Users\limmala.p\Documents\timepoint_merged_final.dta"


// step 7: Calculate total_SFA%, total_MUFA%, total_n3PUFA%, total_n6PUFA%, n3PUFA:n6PUFA%, ARA:DHA, ARA:(EPA + DHA), (EPA + DPA):DHA for v1 and v4 separately and create variables

*SFA*
gen total_v1_SFA_perc = v1_nm_perc8 + v1_nm_perc10 + v1_nm_perc12 + v1_nm_perc14 + v1_nm_perc15 + v1_nm_perc16 + v1_nm_perc18 + v1_nm_perc19 + v1_nm_perc20 + v1_nm_perc22 + v1_nm_perc24 + v1_nm_perc23

gen total_v4_SFA_perc = v4_nm_perc8 + v4_nm_perc10 + v4_nm_perc12 + v4_nm_perc14 + v4_nm_perc15 + v4_nm_perc16 + v4_nm_perc18 + v4_nm_perc19 + v4_nm_perc20 + v4_nm_perc22 + v4_nm_perc24+ v4_nm_perc23 

*MUFA*
gen total_v1_MUFA_perc = v1_nm_perc16_1 + v1_nm_perc18_1w9 + v1_nm_perc18_1w7 + v1_nm_perc20_1w7 + v1_nm_perc20_1w9 + v1_nm_perc22_1w9  + v1_nm_perc24_1 

gen total_v4_MUFA_perc = v4_nm_perc16_1 + v4_nm_perc18_1w9 + v4_nm_perc18_1w7 + v4_nm_perc20_1w7 + v4_nm_perc20_1w9 + v4_nm_perc22_1w9 + v4_nm_perc24_1

*n3PUFA*
gen total_v1_n3PUFA_perc = v1_nm_perc18_3w3 + v1_nm_perc20_3w3 + v1_nm_perc20_5w3 + v1_nm_perc22_5w3 + v1_nm_perc22_6w3 

gen total_v4_n3PUFA_perc = v4_nm_perc18_3w3 + v4_nm_perc20_3w3 + v4_nm_perc20_5w3 + v4_nm_perc22_5w3 + v4_nm_perc24_6w3 //is this correct? there no v4_nm_perc22_6w3? DHA has 22carbons so would be v4_nm_perc22_6w3 for DHA; v4_nm_perc24_6w3 is Nisinic or tetracosenoic acid, right? 

gen v1_EPAandDHA = v1_nm_perc20_5w3 + v1_nm_perc22_6w3

gen v4_EPAandDHA = v4_nm_perc20_5w3 + v4_nm_perc24_6w3 // is this correct? there no v4_nm_perc22_6w3? 24_6w3 is not DHA but 22_6w3 is.
 
*n6PUFA*
gen total_v1_n6PUFA_perc = v1_nm_perc18_2w6 + v1_nm_perc18_3w6 + v1_nm_perc20_2w6 + v1_nm_perc20_3w6 + v1_nm_perc20_4w6 + v1_nm_perc22_4w6 + v1_nm_perc22_5w6 + v1_nm_perc22_2w6

gen total_v4_n6PUFA_perc = v4_nm_perc18_2w6 + v4_nm_perc18_3w6 + v4_nm_perc20_2w6 + v4_nm_perc20_4w6 + v4_nm_perc20_3w6 + v4_nm_perc22_4w6 + v4_nm_perc22_5w6 + v4_nm_perc22_2w6

*total PUFA*
gen total_PUFA_v1 = total_v1_n3PUFA_perc + total_v1_n6PUFA_perc

gen total_PUFA_v4 = total_v4_n3PUFA_perc + total_v4_n6PUFA_perc

*Ratios*
gen v1_ratio_n6byn3PUFAs =  total_v1_n6PUFA_perc/total_v1_n3PUFA_perc

gen v4_ratio_n6byn3PUFAs =  total_v4_n6PUFA_perc/total_v4_n3PUFA_perc

gen v1_ratio_ARAbyDHA = v1_nm_perc20_4w6/ v1_nm_perc22_6w3

gen v4_ratio_ARAbyDHA = v4_nm_perc20_4w6/ v4_nm_perc22_6w3 

gen v1_ratio_ARAbyEPAandDHA = v1_nm_perc20_4w6/ v1_EPAandDHA 

gen v4_ratio_ARAbyEPAandDHA = v4_nm_perc20_4w6/ v4_EPAandDHA 

gen v1_sum_EPAandDPA = v1_nm_perc20_5w3 + v1_nm_perc22_5w3 

gen v4_sum_EPAandDPA = v4_nm_perc20_5w3 + v4_nm_perc22_5w3 

gen v1_ratio_EPAandDPAbyDHA = v1_ratio_EPAandDPA / v1_nm_perc22_6w3 

gen v4_ratio_EPAandDPAbyDHA = v4_ratio_EPAandDPA/ v4_nm_perc22_6w3 

// to check distribution of FA.
histogram v1_nm_perc8
histogram v4_nm_perc8
histogram v1_nm_perc10
histogram v4_nm_perc10
histogram v1_nm_perc12 
histogram v4_nm_perc12
histogram v1_nm_perc14
histogram v4_nm_perc14
histogram v1_nm_perc15
histogram v4_nm_perc15
histogram v1_nm_perc16
histogram v4_nm_perc16
histogram v1_nm_perc18
histogram v4_nm_perc18
histogram v1_nm_perc19 
histogram v4_nm_perc19 
histogram v1_nm_perc22
histogram v4_nm_perc22 
histogram v1_nm_perc24
histogram v4_nm_perc24
histogram v1_nm_perc23
histogram v4_nm_perc23
histogram v1_nm_perc20 
histogram v4_nm_perc20
histogram total_v1_SFA_perc
histogram total_v4_SFA_perc
histogram total_v1_MUFA_perc
histogram total_v4_MUFA_perc
histogram total_v1_n3PUFA_perc
histogram total_v4_n3PUFA_perc
histogram total_v1_n6PUFA_perc
histogram total_v4_n6PUFA_perc
swilk total_v1_n3PUFA_perc

// Spearman's correlation matrix checks if V1 and V4 FA and families are correlated

*SFA*
spearman v1_nm_perc8 v4_nm_perc8
spearman v1_nm_perc10 v4_nm_perc10
spearman v1_nm_perc12 v4_nm_perc12
spearman v1_nm_perc14 v4_nm_perc14
spearman v1_nm_perc15 v4_nm_perc15
spearman v1_nm_perc16 v4_nm_perc16
spearman v1_nm_perc18 v4_nm_perc18
spearman v1_nm_perc19 v4_nm_perc19
spearman v1_nm_perc22 v4_nm_perc22
spearman v1_nm_perc24 v4_nm_perc24
spearman v1_nm_perc23 v4_nm_perc23 
spearman v1_nm_perc20 v4_nm_perc20
spearman v1_nm_perc24 v4_nm_perc24 
spearman total_v1_SFA_perc total_v4_SFA_perc 

*MUFA*
spearman v1_nm_perc16_1 v4_nm_perc16_1
spearman v1_nm_perc18_1w9 v4_nm_perc18_1w9
spearman v1_nm_perc18_1w7 v4_nm_perc18_1w7
spearman v1_nm_perc20_1w7 v4_nm_perc20_1w7
spearman v1_nm_perc20_1w9 v4_nm_perc20_1w9
spearman v1_nm_perc22_1w9 v4_nm_perc22_1w9 
spearman v1_nm_perc24_1 v4_nm_perc24_1 
spearman total_v1_MUFA_perc total_v4_MUFA_perc

*n3PUFA*
spearman v1_nm_perc18_3w3 v4_nm_perc18_3w3
spearman v1_nm_perc20_3w3 v4_nm_perc20_3w3
spearman v1_nm_perc20_5w3 v4_nm_perc20_5w3
spearman v1_nm_perc22_5w3 v4_nm_perc22_5w3
spearman v1_nm_perc22_6w3 v4_nm_perc22_6w3
spearman total_v1_n3PUFA_perc total_v4_n3PUFA_perc

*n6PUFA*
spearman v1_nm_perc18_2w6 v4_nm_perc18_2w6
spearman v1_nm_perc18_3w6 v4_nm_perc18_3w6
spearman v1_nm_perc20_2w6 v4_nm_perc20_2w6 
spearman v1_nm_perc20_3w9  v4_nm_perc20_3w9
spearman v1_nm_perc20_3w6 v4_nm_perc20_3w6
spearman v1_nm_perc20_4w6 v4_nm_perc20_4w6
spearman v1_nm_perc22_4w6 v4_nm_perc22_4w6
spearman v1_nm_perc22_2w6 v4_nm_perc22_2w6
spearman v1_nm_perc22_5w6 v4_nm_perc22_5w6
spearman total_v1_n6PUFA_perc total_v4_n6PUFA_perc

*total PUFA*
spearman total_PUFA_v1 total_PUFA_v4

*ratios*
spearman v1_ratio_n6byn3PUFAs v4_ratio_n6byn3PUFAs
spearman v1_ratio_ARAbyDHA v4_ratio_ARAbyDHA
spearman v1_ratio_ARAbyEPAandDHA v4_ratio_ARAbyEPAandDHA
spearman v1_ratio_EPAandDPAbyDHA v4_ratio_EPAandDPAbyDHA


// Calculate the average 
*average SFA*
gen avg_caprylic = (v1_nm_perc8 + v4_nm_perc8) / 2
gen avg_capric = (v1_nm_perc10 + v4_nm_perc10) / 2
gen avg_lauric = (v1_nm_perc12 + v4_nm_perc12) / 2
gen avg_myristic = (v1_nm_perc14 + v4_nm_perc14) / 2
gen avg_pentadecylic = (v1_nm_perc15 + v4_nm_perc15) / 2
gen avg_palmitic = (v1_nm_perc16 + v4_nm_perc16) / 2
gen avg_stearic = (v1_nm_perc18 + v4_nm_perc18) / 2
gen avg_nonadecanoic = (v1_nm_perc19 + v4_nm_perc19) / 2
gen avg_docosanoic = (v1_nm_perc22 + v4_nm_perc22) / 2
gen avg_tetracosanoic = (v1_nm_perc24 + v4_nm_perc24) / 2
gen avg_tricosylic = (v1_nm_perc23 + v4_nm_perc23) / 2
gen avg_arachidic = (v1_nm_perc20 + v4_nm_perc20) / 2
gen avg_SFA = (total_v1_SFA_perc + total_v4_SFA_perc)/2

*average MUFA*
gen avg_palmitoleic = (v1_nm_perc16_1 + v4_nm_perc16_1) / 2
gen avg_oleic = (v1_nm_perc18_1w9 + v4_nm_perc18_1w9) / 2
gen avg_vaccenic = (v1_nm_perc18_1w7 + v4_nm_perc18_1w7) / 2
gen avg_eicosenoic = (v1_nm_perc20_1w7 + v4_nm_perc20_1w7) / 2
gen avg_gadoleic = (v1_nm_perc20_1w9 + v4_nm_perc20_1w9) / 2
gen avg_erucic = (v1_nm_perc22_1w9 + v4_nm_perc22_1w9) / 2
gen avg_nervonic = (v1_nm_perc24_1 + v4_nm_perc24_1) / 2
gen avg_MUFA = (total_v1_MUFA_perc + total_v4_MUFA_perc)/2


*average n3 PUFA*
gen avg_ala = (v1_nm_perc18_3w3 + v4_nm_perc18_3w3) / 2
gen avg_eicosatrienoic = (v1_nm_perc20_3w3 + v4_nm_perc20_3w3) / 2
gen avg_eicosapentaenoic = (v1_nm_perc20_5w3 + v4_nm_perc20_5w3) / 2
gen avg_dpan3 = (v1_nm_perc22_5w3 + v4_nm_perc22_5w3) / 2
gen avg_docosahexaenoic = (v1_nm_perc22_6w3 + v4_nm_perc22_6w3) / 2 
gen avg_n3PUFA = (total_v1_n3PUFA_per + total_v4_n3PUFA_perc)/2

*average n6PUFA*
gen avg_linoleic = (v1_nm_perc18_2w6 + v4_nm_perc18_2w6) / 2
gen avg_gamma_linolenic = (v1_nm_perc18_3w6 + v4_nm_perc18_3w6) / 2
gen avg_eicosadienoic = (v1_nm_perc20_2w6 + v4_nm_perc20_2w6) / 2
gen avg_dgla = (v1_nm_perc20_3w6 + v4_nm_perc20_3w6) / 2
gen avg_arachidonic = (v1_nm_perc20_4w6 + v4_nm_perc20_4w6) / 2
gen avg_adrenic_acid = (v1_nm_perc22_4w6 + v4_nm_perc22_4w6) / 2
gen avg_dpan6 = (v1_nm_perc22_5w6 + v4_nm_perc22_5w6) / 2
gen avg_docosadienoicacid = (v1_nm_perc22_2w6 + v4_nm_perc22_2w6) / 2
gen avg_n6PUFA = (total_v1_n6PUFA_perc + total_v4_n6PUFA_perc)/2

*total PUFA*
gen avg_PUFA = (total_PUFA_v1 + total_PUFA_v4 + v4_nm_perc20_3w9)/ 2 

*Ratios*
gen avg_ratio__n6byn3PUFAs = (v1_ratio_n6byn3PUFAs + v4_ratio_n6byn3PUFAs)/ 2
gen avg_ratio_ARAbyDHA = (v1_ratio_ARAbyDHA + v4_ratio_ARAbyDHA)/2
gen avg_ratio_ARAbyEPAandDHA = (v1_ratio_ARAbyEPAandDHA + v4_ratio_ARAbyEPAandDHA)/2
gen avg_ratio_EPAandDPAbyDHA = (v1_ratio_EPAandDPAbyDHA + v4_ratio_EPAandDPAbyDHA)/2

save "C:\Users\limmala.p\Documents\final run\analytical_data_final.dta" 


// To calculate median(IQR)
*SFA*
sum avg_caprylic, d
sum avg_capric, d
sum avg_lauric, d
sum avg_myristic, d
sum avg_pentadecylic, d
sum avg_palmitic, d
sum avg_stearic, d
sum avg_nonadecanoic, d
sum avg_docosanoic, d
sum avg_tetracosanoic, d
sum avg_tricosylic, d
sum avg_arachidic, d
sum avg_SFA, d

* MUFA*
sum avg_palmitoleic, d
sum avg_oleic, d
sum avg_vaccenic, d
sum avg_eicosenoic, d
sum avg_gadoleic, d
sum avg_erucic, d
sum avg_nervonic, d
sum avg_MUFA, d

*n3 PUFA*
sum avg_ala, d
sum avg_eicosatrienoic, d
sum avg_eicosapentaenoic, d
sum avg_dpan3, d
sum avg_docosahexaenoic, d
sum avg_n3PUFA, d

*n6PUFA*
sum avg_linoleic, d
sum avg_gamma_linolenic, d
sum avg_eicosadienoic, d
sum avg_dgla, d
sum avg_arachidonic, d
sum avg_adrenic_acid, d
sum avg_dpan6, d
sum avg_docosadienoicacid, d
sum avg_n6PUFA, d

*total PUFA*
sum avg_PUFA, d

* Ratios*
sum avg_ratio__n6byn3PUFAs, d
sum avg_ratio_ARAbyDHA, d
sum avg_ratio_ARAbyEPAandDHA, d
sum avg_ratio_EPAandDPAbyDHA, d



// unstring all the stringed variables
encode typedelivb1_delivery_t1, generate(delivery_type)
encode woman_id, generate(id_woman)
encode datevisit_baseline, generate(date_of_visit)
encode pdatevisit_delivery_t1, generate(dov_t1_delivery)
encode numpnvisit_delivery_t1, generate(nov_t1_delivery)
encode p1dateb_postnatal_t1, generate(dov_t1_postnatal)
encode hiv_postnatal_t1, generate(hiv_t1_postnatal)
encode malar_postnatal_t1, generate(malar_t1_postnatal)
encode tuber_postnatal_t1, generate(tuber_t1_postnatal)
encode hepb_postnatal_t1, generate(hepb_t1_postnatal)
encode hepc_postnatal_t1, generate(hepc_t1_postnatal)
encode uti_postnatal_t1, generate(uti_t1_postnatal)
encode pdatevisit_postnatal_t1, generate(pdate_of_visit_t1)
encode pdatevisit_postnatal_t2, generate(pdate_of_visit_t2)
encode numpnvisit_postnatal_t1, generate(pnov_t1)
encode numpnvisit_postnatal_t2, generate(pnov_t2)
encode study, generate(study_type)
encode wealth_quintile_1_ses, generate(wealth_index)
encode p1dateb_postnatal_t2, generate(dov_t2_postnatal)
encode hiv_postnatal_t2, generate(hiv_t2_postnatal)
encode malar_postnatal_t2, generate(malar_t2_postnatal)
encode tuber_postnatal_t2, generate(tuber_t2_postnatal)
encode hepb_postnatal_t2, generate(hepb_t2_postnatal)
encode hepc_postnatal_t2, generate(hepc_t2_postnatal)
encode uti_postnatal_t2, generate(uti_t2_postnatal)

save "C:\Users\limmala.p\Documents\final run\analytical_data_final.dta" 


*Data Analysis*                                            
* Maternal Characteristics
// age
histogram motherage_baseline, normal
graph box motherage_baseline
swilk motherage_baseline
summarize motherage_baseline, detail

//parity
// Categorize parity_baseline as nulliparity, primiparity, and multiparity
gen parity_category = ""
replace parity_category = "nulliparity" if parity_baseline == 0 | parity_baseline == 99
replace parity_category = "primiparity" if parity_baseline == 1
replace parity_category = "multiparity" if parity_baseline >= 2
tab parity_category

//education
histogram motheredu_baseline, normal
graph box motheredu_baseline
swilk motheredu_baseline
summarize motheredu_baseline, detail

// wealth index
* Categorize wealth index
gen wealth_cat = ""
replace wealth_cat = "Higher Quintile" if wealth_quintile_ == "Higher quintile"
replace wealth_cat = "Highest Quintile" if wealth_quintile_ == "Highest Quintile"
replace wealth_cat = "Lower Quintile" if wealth_quintile_ == "Lower Quintile"
replace wealth_cat = "Lowest Quintile" if wealth_quintile_ == "Lowest Quintile"
replace wealth_cat = "Middle Quintile" if wealth_quintile_ == "Middle quintile"

tab wealth_cat
graph pie ,over(wealth_cat) ///
          title("Wealth Quintile Categories")
graph bar , over(wealth_cat, label(labsize(small))) ///
          title("Wealth Quintile Categories") ///
          ylabel(0(10)40) ytitle("Frequency")

// BMI enrollment and Categorize BMI
* Calculate BMI
gen bmi_baseline = matweight_baseline / (matheight_baseline / 100) ^ 2
swilk bmi_baseline
summarize bmi_baseline, detail
histogram bmi_baseline
gen bmi_cat_base = ""
replace bmi_cat_base = "Underweight" if bmi_baseline < 18.5
replace bmi_cat_base = "Normal" if bmi_baseline >= 18.5 & bmi_baseline <= 22.9
replace bmi_cat_base = "Overweight" if bmi_baseline > 22.9
replace bmi_cat_base = "Obese" if bmi_baseline >= 30
graph bar (count) bmi_baseline, over(bmi_cat_base, label(labsize(small))) ///
    bar(1, color(blue)) bar(2, color(green)) bar(3, color(red)) bar(4, color(purple)) ///
    title("BMI Categories") ylabel(0(10)60) ytitle("Frequency")
tab bmi_cat_base

// muac
histogram matmuac_baseline, normal
summarize matmuac_baseline, detail

* Create a new variable to store the categories
gen muac_category = ""

* Categorize MUAC measurements
replace muac_category = "Severe Acute Malnutrition" if matmuac_baseline < 23
replace muac_category = "Moderate Acute Malnutrition" if matmuac_baseline >= 23 & matmuac_baseline < 24
replace muac_category = "Normal or Adequate" if matmuac_baseline >= 24

* Display the categorized data
tabulate muac_category

* Infant Characteristics
// infant sex
histogram infant_sex, normal
tabulate infant_sex
// Categorize infant_sex as male (0) and female (1)
recode infant_sex (0 = 1 "Female") (1 = 2 "Male"), generate(infant_sex_cat)
tab infant_sex_cat

// GA at delivery
histogram gestational_age_birth, normal
graph box gestational_age_birth
swilk gestational_age_birth
summarize gestational_age_birth, detail

// Preterm delivery
* Generate preterm_delivery variable
gen preterm_delivery = ""
* Check the data type of preterm_delivery variable
di type preterm_delivery
* Convert preterm_delivery variable to numeric if needed
tostring preterm_delivery, replace
destring preterm_delivery, replace
* Assign values to preterm_delivery variable
replace preterm_delivery = 0 if inrange(gestational_age_birth, 37, 39)
replace preterm_delivery = 1 if gestational_age_birth < 37
tab preterm_delivery

// infant birthweight
histogram birth_weight_avg, normal
graph box birth_weight_avg
swilk birth_weight_avg
summarize birth_weight_avg, detail


// timing of milk collection
*Recorded time from shared information by Chloe* ////WHERE IS THIS DATA? you should show how you imported chloe's file and merge with your analytical dataset

// Categorize birth_weight_centile into SGA, LGA, and AGA 
gen sga = ""
replace sga = "SGA" if birth_weight_centile < 10
replace sga = "LGA" if birth_weight_centile > 90
replace sga = "AGA" if missing(birth_weight_centile) | (birth_weight_centile >= 10 & birth_weight_centile <= 90)

*Tabulate sga variable
tabulate sga

save "C:\Users\limmala.p\Documents\final run\analytical_data_final.dta" 


