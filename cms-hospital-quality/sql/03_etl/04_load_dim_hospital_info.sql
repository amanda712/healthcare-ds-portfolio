-- ------------------------------------------------------------
-- load_dim_hospital_info
-- ------------------------------------------------------------

CREATE OR REPLACE PROCEDURE staging.load_dim_hospital_info()
LANGUAGE plpgsql AS $$
-- set up variables to track data movement during the ETL process
DECLARE
	v_rows_staged	BIGINT;
	v_rows_inserted	INT;

BEGIN
	-- Count staged rows
	SELECT COUNT(*) INTO v_rows_staged FROM staging.stg_hospital_gen_info;

-- Delete rows from the table if they already exist
TRUNCATE core.dim_hospital_infoe;

-- Insert into production
WITH hosp_survey AS (
	SELECT DISTINCT hps.facility_id,
	(CASE
		WHEN hps.number_completed_surveys IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hps.number_completed_surveys::INT
	END) number_completed_surveys,
	(CASE
		WHEN hps.survey_response_percent_rate IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hps.survey_response_percent_rate::INT
	END) survey_response_percent_rate
	FROM staging.stg_hospital_patient_survey hps),
inserted AS (
	INSERT INTO core.dim_hospital_info (
		facility_id,
		facility_name,
		address,
		city,
		state,
		zip_code,
		hospital_type,
		hospital_ownership,
		emergency_services,
		overall_rating,
		number_completed_surveys,
		survey_response_percent_rate,
		mort_group_measure_count,
		mort_facility_measure_count,
		mort_better_count,
		mort_same_count,
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
		timely_eff_facility_measure_count
	)
	SELECT
	hgi.facility_id::VARCHAR(6),
	NULLIF(hgi.facility_name, '')::VARCHAR(74),
	NULLIF(hgi.address, '')::VARCHAR(51),
	NULLIF(hgi.city_town, '')::VARCHAR(24),
	NULLIF(hgi.state, '')::VARCHAR(2),
	NULLIF(hgi.zip_code, '')::VARCHAR(8),
	NULLIF(hgi.hospital_type, '')::VARCHAR(36),
	NULLIF(hgi.hospital_ownership, '')::VARCHAR(43),
	NULLIF(hgi.emergency_services, '')::VARCHAR(3),
	CASE
		WHEN hgi.hospital_overall_rating IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.hospital_overall_rating::INT
	END,
	hs.number_completed_surveys, 
	hs.survey_response_percent_rate,
	CASE
		WHEN hgi.mort_group_measure_count IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.mort_group_measure_count::INT
	END,
	CASE
		WHEN hgi.count_facility_mort_measures IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.count_facility_mort_measures::INT
	END,
	CASE
		WHEN hgi.count_mort_measures_better IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.count_mort_measures_better::INT
	END,
	CASE
		WHEN hgi.count_mort_measures_no_different IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.count_mort_measures_no_different::INT
	END,
	CASE
		WHEN hgi.count_mort_measures_worse IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.count_mort_measures_worse::INT
	END,
	CASE
		WHEN hgi.safety_group_measure_count IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.safety_group_measure_count::INT
	END,
	CASE
		WHEN hgi.count_facility_safety_measures IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.count_facility_safety_measures::INT
	END,
	CASE
		WHEN hgi.count_safety_measures_better IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.count_safety_measures_better::INT
	END,
	CASE
		WHEN hgi.count_safety_measures_no_different IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.count_safety_measures_no_different::INT
	END,
	CASE
		WHEN hgi.count_safety_measures_worse IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.count_safety_measures_worse::INT
	END,
	CASE
		WHEN hgi.readm_group_measure_count IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.readm_group_measure_count::INT
	END,
	CASE
		WHEN hgi.count_facility_readm_measures IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.count_facility_readm_measures::INT
	END,
	CASE
		WHEN hgi.count_readm_measures_better IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.count_readm_measures_better::INT
	END,
	CASE
		WHEN hgi.count_readm_measures_no_different IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.count_readm_measures_no_different::INT
	END,
	CASE
		WHEN hgi.count_readm_measures_worse IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.count_readm_measures_worse::INT
	END,
	CASE
		WHEN hgi.pt_exp_group_measure_count IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.pt_exp_group_measure_count::INT
	END,
	CASE
		WHEN hgi.count_facility_pt_exp_measures IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.count_facility_pt_exp_measures::INT
	END,
	CASE
		WHEN hgi.te_group_measure_count IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.te_group_measure_count::INT
	END,
	CASE
		WHEN hgi.count_facility_te_measures IN ('', 'Not Available', 'Not Applicable') THEN NULL
		ELSE hgi.count_facility_te_measures::INT
	END
	FROM staging.stg_hospital_gen_info hgi
		LEFT JOIN hosp_survey hs ON hgi.facility_id = hs.facility_id
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
		'core.dim_hospital_info',
		v_rows_staged,
		v_rows_inserted, 
		v_rows_staged - v_rows_inserted, 
		'success',
		NULL
	);

	RAISE NOTICE 'load_dim_hospital_info: % staged, % inserted, % skipped',
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
		'core.dim_hospital_info',
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
CALL staging.load_dim_hospital_info();

-- check the import_log
SELECT * FROM staging.import_log;

