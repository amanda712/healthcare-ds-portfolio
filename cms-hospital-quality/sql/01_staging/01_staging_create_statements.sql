/* CREATE script for staging tables */


-- Drop tables if they already exist
DROP TABLE IF EXISTS staging.stg_footnote_crosswalk;
DROP TABLE IF EXISTS staging.stg_hospital_gen_info;
DROP TABLE IF EXISTS staging.stg_hospital_patient_survey;



-- Table structure for `footnote_crosswalk`
CREATE TABLE staging.stg_footnote_crosswalk (
	footnote VARCHAR(6),
	footnote_text VARCHAR(230)
);


-- Table structure for `hospital_gen_info`
CREATE TABLE staging.stg_hospital_gen_info (
	facility_id VARCHAR(6),
	facility_name VARCHAR(74),
	address VARCHAR(51),
	city_town VARCHAR(24),
	state VARCHAR(2),
	zip_code VARCHAR(8),
	county_parish VARCHAR(25),
	telephone_number VARCHAR(14),
	hospital_type VARCHAR(36),
	hospital_ownership VARCHAR(43),
	emergency_services VARCHAR(3),
	meets_criteria_birthing_friendly_designation VARCHAR(1),
	hospital_overall_rating VARCHAR(13),
	hospital_overall_rating_footnote VARCHAR(8),
	mort_group_measure_count VARCHAR(13),
	count_facility_mort_measures VARCHAR(13),
	count_mort_measures_better VARCHAR(13),
	count_mort_measures_no_different VARCHAR(13),
	count_mort_measures_worse VARCHAR(13),
	mort_group_footnote CHAR(8),
	safety_group_measure_count VARCHAR(13),
	count_facility_safety_measures VARCHAR(13),
	count_safety_measures_better VARCHAR(13),
	count_safety_measures_no_different VARCHAR(13),
	count_safety_measures_worse VARCHAR(13),
	safety_group_footnote CHAR(8),
	readm_group_measure_count VARCHAR(13),
	count_facility_readm_measures VARCHAR(13),
	count_readm_measures_better VARCHAR(13),
	count_readm_measures_no_different VARCHAR(13),
	count_readm_measures_worse VARCHAR(13),
	readm_group_footnote CHAR(8),
	pt_exp_group_measure_count VARCHAR(13),
	count_facility_pt_exp_measures VARCHAR(13),
	pt_exp_group_footnote CHAR(8),
	te_group_measure_count VARCHAR(13),
	count_facility_te_measures VARCHAR(13),
	te_group_footnote CHAR(8)
);


-- Table structure for `hospital_patient_survey`
CREATE TABLE staging.stg_hospital_patient_survey (
	facility_id VARCHAR(6),
	facility_name VARCHAR(74),
	address VARCHAR(51),
	city_town VARCHAR(24),
	state VARCHAR(2),
	zip_code INT,
	county_parish VARCHAR(25),
	telephone_number VARCHAR(14),
	hcahps_measure_id VARCHAR(30),
	hcahps_question VARCHAR(150),
	hcahps_answer_description VARCHAR(115),
	patient_survey_star_rating VARCHAR(15),
	patient_survey_star_rating_footnote VARCHAR(8),
	hcahps_answer_percent VARCHAR(15),
	hcahps_answer_percent_footnote VARCHAR(8),
	hcahps_linear_mean_value VARCHAR(15),
	number_completed_surveys VARCHAR(15),
	number_completed_surveys_footnote VARCHAR(8),
	survey_response_percent_rate VARCHAR(15),
	survey_response_percent_rate_footnote VARCHAR(8),
	start_date DATE,
	end_date DATE
);



/* Confirm row counts and table joins 

SELECT COUNT(*) from staging.stg_footnote_crosswalk;
-- 32 rows
SELECT COUNT(*) from staging.stg_hospital_gen_info;
-- 5,426 rows
SELECT COUNT(*) from staging.stg_hospital_patient_survey;
-- 32,5652 rows


SELECT hg.facility_id, hg.state, hg.facility_name, hp.facility_id
FROM staging.stg_hospital_gen_info hg 
	FULL OUTER JOIN staging.stg_hospital_patient_survey hp ON hg.facility_id = hp.facility_id
WHERE hp.facility_id IS NULL;
-- 637 rows missing patient_survey


SELECT hg.facility_id, hg.hospital_overall_rating, hg.hospital_overall_rating_footnote
FROM staging.stg_hospital_gen_info hg
WHERE hg.hospital_overall_rating_footnote IS NOT NULL;

SELECT hg.facility_id, hg.hospital_overall_rating_footnote, fc.footnote_text
FROM staging.stg_hospital_gen_info hg
	JOIN staging.stg_footnote_crosswalk fc ON hg.hospital_overall_rating_footnote = fc.footnote
WHERE hg.facility_id = '010008';

SELECT hp.facility_id, hp.patient_survey_star_rating_footnote, fc.footnote_text
FROM staging.stg_hospital_patient_survey hp
	JOIN staging.stg_footnote_crosswalk fc ON hp.patient_survey_star_rating_footnote = fc.footnote
WHERE hp.facility_id = '010008';

*/