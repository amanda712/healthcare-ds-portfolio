/* CREATE script for staging tables */


-- Drop tables if they already exist
DROP TABLE IF EXISTS staging.footnote_crosswalk;
DROP TABLE IF EXISTS staging.hospital_gen_info;
DROP TABLE IF EXISTS staging.hospital_patient_survey;



-- Table structure for `footnote_crosswalk`
CREATE TABLE staging.footnote_crosswalk (
	footnote VARCHAR(6),
	footnote_text VARCHAR(230)
);


-- Table structure for `hospital_gen_info`
CREATE TABLE staging.hospital_gen_info (
	facility_id VARCHAR(6),
	facility_name VARCHAR(74),
	address VARCHAR(51),
	city_town VARCHAR(24),
	state VARCHAR(2),
	zip_code INT,
	county_parish VARCHAR(25),
	telephone_number VARCHAR(14),
	hospital_type VARCHAR(36),
	hospital_ownership VARCHAR(43),
	emergency_services VARCHAR(3),
	meets_criteria_birthing VARCHAR(1),
	hospital_overall_rating VARCHAR(13),
	hospital_overall_rating_footnote VARCHAR(8),
	mort_group_measure_count VARCHAR(13),
	mort_facility_measure_count VARCHAR(13),
	mort_better_count VARCHAR(13),
	mort_same_count VARCHAR(13),
	mort_worse_count VARCHAR(13),
	mort_group_footnote CHAR(8),
	safety_group_measure_count VARCHAR(13),
	safety_facility_measure_count VARCHAR(13),
	safety_better_count VARCHAR(13),
	safety_same_count VARCHAR(13),
	safety_worse_count VARCHAR(13),
	safety_group_footnote CHAR(8),
	readm_group_measure_count VARCHAR(13),
	readm_facility_measure_count VARCHAR(13),
	readm_better_count VARCHAR(13),
	readm_same_count VARCHAR(13),
	readm_worse_count VARCHAR(13),
	readm_group_footnote CHAR(8),
	pt_exp_group_measure_count VARCHAR(13),
	pt_exp_facility_measure_count VARCHAR(13),
	pt_exp_group_footnote CHAR(8),
	time_eff_group_measure_count VARCHAR(13),
	time_eff_facility_measure_count VARCHAR(13),
	time_eff_group_footnote CHAR(8)
);


-- Table structure for `hospital_patient_survey`
CREATE TABLE staging.hospital_patient_survey (
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


SELECT COUNT(*) from staging.footnote_crosswalk;
-- 32 rows
SELECT COUNT(*) from staging.hospital_gen_info;
-- 5,426 rows
SELECT COUNT(*) from staging.hospital_patient_survey;
-- 32,5652 rows
