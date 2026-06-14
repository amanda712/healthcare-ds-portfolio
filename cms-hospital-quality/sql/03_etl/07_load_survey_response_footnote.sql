-- ------------------------------------------------------------
-- load_survey_response_footnote
-- ------------------------------------------------------------

CREATE OR REPLACE PROCEDURE staging.load_survey_response_footnote()
LANGUAGE plpgsql AS $$
-- set up variables to track data movement during the ETL process
DECLARE
	v_rows_staged	BIGINT;
	v_rows_inserted	INT;

BEGIN
	-- Count staged rows
	-- SELECT COUNT(*) INTO v_rows_staged FROM staging.stg_hospital_patient_survey; 
		-- This is replaced with the UNION ALL COUNT below

SELECT COUNT(*) INTO v_rows_staged
FROM (
	SELECT facility_id, 'patient_star_rating' AS footnote_context,
		TRIM(UNNEST(string_to_array(patient_survey_star_rating_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_patient_survey
	WHERE patient_survey_star_rating_footnote IS NOT NULL 
		AND patient_survey_star_rating_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, 'answer_percent' AS footnote_context,
		TRIM(unnest(string_to_array(hcahps_answer_percent_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_patient_survey
	WHERE hcahps_answer_percent_footnote IS NOT NULL 
		AND hcahps_answer_percent_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, 'number_completed_surveys' AS footnote_context,
		TRIM(unnest(string_to_array(number_completed_surveys_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_patient_survey
	WHERE number_completed_surveys_footnote IS NOT NULL
		AND number_completed_surveys_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, 'survey_response_percent_rate' AS footnote_context,
		TRIM(unnest(string_to_array(survey_response_percent_rate_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_patient_survey
	WHERE survey_response_percent_rate_footnote IS NOT NULL
		AND survey_response_percent_rate_footnote != ''
) footnotes;

-- Delete rows from the table if they alraedy exist
TRUNCATE core.survey_response_footnote;

-- Insert into production
WITH inserted AS (
	INSERT INTO core.survey_response_footnote (
		facility_id,
		measure_id,
		footnote_context,
		footnote_id
	)
	SELECT facility_id, hcahps_measure_id, 'patient_star_rating' AS footnote_context,
		TRIM(UNNEST(string_to_array(patient_survey_star_rating_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_patient_survey
	WHERE patient_survey_star_rating_footnote IS NOT NULL 
		AND patient_survey_star_rating_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, hcahps_measure_id, 'answer_percent' AS footnote_context,
		TRIM(unnest(string_to_array(hcahps_answer_percent_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_patient_survey
	WHERE hcahps_answer_percent_footnote IS NOT NULL 
		AND hcahps_answer_percent_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, hcahps_measure_id, 'number_completed_surveys' AS footnote_context,
		TRIM(unnest(string_to_array(number_completed_surveys_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_patient_survey
	WHERE number_completed_surveys_footnote IS NOT NULL
		AND number_completed_surveys_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, hcahps_measure_id, 'survey_response_percent_rate' AS footnote_context,
		TRIM(unnest(string_to_array(survey_response_percent_rate_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_patient_survey
	WHERE survey_response_percent_rate_footnote IS NOT NULL
		AND survey_response_percent_rate_footnote != ''

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
		'core.survey_response_footnote',
		v_rows_staged,
		v_rows_inserted,
		v_rows_staged - v_rows_inserted,
		'success',
		NULL
	);

	RAISE NOTICE 'load survey_response_footnote: % staged, % inserted, % skipped',
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
		'core.survey_response_footnote',
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
CALL staging.load_survey_response_footnote();

-- check the import_log
SELECT * FROM staging.import_log;
