-- ============================================================
-- Create import_log in the staging schema
-- ============================================================

CREATE TABLE staging.import_log (
    import_log_id	UUID            NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    target_table    TEXT            NOT NULL,
    rows_staged     INT,
    rows_inserted   INT,
    rows_skipped    INT,
    status          TEXT            NOT NULL DEFAULT 'success',
	notes			TEXT,
    imported_at     TIMESTAMPTZ     NOT NULL DEFAULT now()
);



-- ============================================================
-- Create production tables in core schema
-- ============================================================

-- core.footnote
-- lookup/reference table
CREATE TABLE core.footnote (
	footnote_id		VARCHAR(3) PRIMARY KEY,
	footnote_text	VARCHAR(230),
	created_date	TIMESTAMPTZ NOT NULL DEFAULT now(),
	modified_date	TIMESTAMPTZ NOT NULL DEFAULT now()
);



-- core.dim_hospital_info
-- dimension table
CREATE TABLE core.dim_hospital_info (
	facility_id						VARCHAR(3) PRIMARY KEY,
	facility_name					VARCHAR(24),
	address							VARCHAR(24),
	city							VARCHAR(24),
	state							VARCHAR(2),
	zip_code						VARCHAR(5),
	hospital_type					VARCHAR(36),
	hospital_ownership				VARCHAR(36),
	emergency_services				VARCHAR(3),
	overall_rating					INT,
	number_completed_surveys		INT,
	survey_response_percent_rate	INT,
	mort_group_masure_count			INT,
	mort_facility_measure_count		INT,
	mort_better_count				INT,
	mort_same_count				,
	mort_worse_count,
	safety_group_measure_count,
	safety_facility_measure_count,
	safety_better_count,
	safety_same_count,
	safety_worse_count,
	readm_group_measure_count,
	readm_facility_measure_count,
	readm_better_count,
	readm_same_count,
	readm_worse_count,
	pt_exp_group_measure_count,
	pt_exp_facility_measure_count,
	timely_eff_group_measure_count,
	timely_eff_facility_measure_count,
	created_date	TIMESTAMPTZ NOT NULL DEFAULT now(),
	modified_date	TIMESTAMPTZ NOT NULL DEFAULT now()
);



-- core.hospital_info_footnote
-- bridge table
CREATE TABLE core.hospital_info_footnote (
	facility_id 		VARCHAR(6),
	footnote_context 	VARCHAR(15),
	footnote_id 		VARCHAR(8),
	created_date		TIMESTAMPTZ NOT NULL DEFAULT now(),
	modified_date		TIMESTAMPTZ NOT NULL DEFAULT now(),
	PRIMARY KEY(facility_id, footnote_context, footnote_id)
);


-- core.fact_survey_reponse
-- fact table
CREATE TABLE core.fact_survey_response (
	facility_id					VARCHAR(6),
	measure_id					VARCHAR(30),
	hcahps_question				VARCHAR(150),
	hcahps_answer_description	VARCHAR(115),
	patient_survey_star_rating	INT,
	hcahps_answer_percent		INT,
	hcahps_linear_mean_value	DECIMAL,
	response_type				VARCHAR(20),
	created_date				TIMESTAMPTZ NOT NULL DEFAULT now(),
	modified_date				TIMESTAMPTZ NOT NULL DEFAULT now(),
	PRIMARY KEY(facility_id, measure_id)
);


-- core.survey_response_footnote
-- bridge table
CREATE TABLE core.survey_response_footnote(
	facility_id			VARCHAR(6),
	measure_id			VARCHAR(30),
	footnote_context	VARCHAR(15),
	footnote_id			VARCHAR(3),
	created_date		TIMESTAMPTZ NOT NULL DEFAULT now(),
	modified_date		TIMESTAMPTZ NOT NULL DEFAULT now(),
	PRIMARY KEY(facility_id, measure_id, footnote_context, footnote_id)
);

