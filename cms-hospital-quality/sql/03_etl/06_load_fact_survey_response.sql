-- ------------------------------------------------------------
-- load_fact_survey_response
-- ------------------------------------------------------------

CREATE OR REPLACE PROCEDURE staging.load_fact_survey_response()
LANGUAGE plpgsql AS $$
-- set up variables to track data movement during the ETL process
DECLARE
	v_rows_staged	BIGINT;
	v_rows_inserted	INT;

BEGIN
	-- Count staged rows
	SELECT COUNT(*) INTO v_rows_staged FROM staging.stg_hospital_patient_survey;

-- Delete rows from the table if they already exist
TRUNCATE core.fact_survey_response;

-- Insert into production
WITH inserted AS (
	INSERT INTO core.fact_survey_response (
		facility_id,
		measure_id,
		hcahps_question,
		hcahps_answer_description,
		patient_survey_star_rating,
		hcahps_answer_percent,
		hcahps_linear_mean_value,
		response_type
	)
	SELECT hps.facility_id::VARCHAR(6),
	hps.hcahps_measure_id::VARCHAR(30),
	hps.hcahps_question::VARCHAR(150),
	hps.hcahps_answer_description::VARCHAR(115),
	CASE
		WHEN hps.patient_survey_star_rating IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hps.patient_survey_star_rating::INT
	END AS patient_survey_star_rating,
	CASE
		WHEN hps.hcahps_answer_percent IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hps.hcahps_answer_percent::INT
	END AS hcahps_answer_percent,
	CASE
		WHEN hps.hcahps_linear_mean_value IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hps.hcahps_linear_mean_value::INT
	END AS hcahps_linear_mean_value,
	CASE
	    WHEN hcahps_measure_id LIKE '%_LINEAR_SCORE' THEN 'linear_mean'
    	WHEN hcahps_measure_id LIKE '%_STAR_RATING' THEN 'star_rating'
    	ELSE 'response_distribution'	
	END::VARCHAR(24) AS response_type
	FROM staging.stg_hospital_patient_survey hps

	RETURNING 1
	)

	SELECT COUNT(*) INTO v_rows_inserted FROM inserted;

	-- Log the result (success)
	-- Using VALUES to ensure only one row is inserted into the log
	INSERT INTO staging.import_log (
    target_table,
    rows_staged, 
	rows_inserted, 
	rows_skipped, 
	status,
	notes
	)
	VALUES (
		'core.fact_survey_response',
		v_rows_staged,
		v_rows_inserted, 
		v_rows_staged - v_rows_inserted, 
		'success',
		NULL
	);

	RAISE NOTICE 'load_fact_survey_response: % staged, % inserted, % skipped',
		v_rows_staged, v_rows_inserted, v_rows_staged - v_rows_inserted;
	
EXCEPTION WHEN OTHERS THEN
	-- Log the errors
	INSERT INTO staging.import_log (
		target_table, 
		rows_staged, 
		rows_inserted, 
		rows_skipped, 
		status,
		notes
	)
	VALUES (
		'core.fact_survey_response',
		v_rows_staged, 
		0, 
		0, 
		'error', 
		SQLERRM
	);

	RAISE;
END;
$$;


-- run the procedure
CALL staging.load_fact_survey_response()

-- check the import_log
SELECT * FROM staging.import_log;

