-- ------------------------------------------------------------
-- load_hospital_info_footnote
-- ------------------------------------------------------------

CREATE OR REPLACE PROCEDURE staging.load_hospital_info_footnote()
LANGUAGE plpgsql AS $$
-- set up variables to track data movement during the ETL process
DECLARE
	v_rows_staged	BIGINT;
	v_rows_inserted	INT;

BEGIN
	-- Count staged rows
	-- SELECT COUNT(*) INTO v_rows_staged FROM staging.stg_hospital_gen_info; 
		-- This is replaced with the UNION ALL COUNT below


SELECT COUNT(*) INTO v_rows_staged
FROM (
    SELECT facility_id, 'overall_rating' AS footnote_context,
		TRIM(UNNEST(string_to_array(hospital_overall_rating_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_gen_info
	WHERE hospital_overall_rating_footnote IS NOT NULL 
	    AND hospital_overall_rating_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, 'mort_group' AS footnote_context,
	    TRIM(unnest(string_to_array(mort_group_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_gen_info
	WHERE mort_group_footnote IS NOT NULL 
	    AND mort_group_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, 'safety_group' AS footnote_context,
		TRIM(unnest(string_to_array(safety_group_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_gen_info
	WHERE safety_group_footnote IS NOT NULL
		AND safety_group_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, 'readm_group' AS footnote_context,
		TRIM(unnest(string_to_array(readm_group_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_gen_info
	WHERE readm_group_footnote IS NOT NULL
		AND readm_group_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, 'pt_exp_group' AS footnote_context,
		TRIM(unnest(string_to_array(pt_exp_group_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_gen_info
	WHERE pt_exp_group_footnote IS NOT NULL
		AND pt_exp_group_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, 'te_group' AS footnote_context,
		TRIM(unnest(string_to_array(te_group_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_gen_info
	WHERE te_group_footnote IS NOT NULL
		AND te_group_footnote != ''
) footnotes;

-- Delete rows from the table if they already exist
TRUNCATE core.hospital_info_footnote;

-- Insert into production
WITH inserted AS (
	INSERT INTO core.hospital_info_footnote(
		facility_id,
		footnote_context,
		footnote_id
	)	
	SELECT facility_id, 'overall_rating' AS footnote_context,
		TRIM(UNNEST(string_to_array(hospital_overall_rating_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_gen_info
	WHERE hospital_overall_rating_footnote IS NOT NULL 
	    AND hospital_overall_rating_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, 'mort_group' AS footnote_context,
	    TRIM(unnest(string_to_array(mort_group_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_gen_info
	WHERE mort_group_footnote IS NOT NULL 
	    AND mort_group_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, 'safety_group' AS footnote_context,
		TRIM(unnest(string_to_array(safety_group_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_gen_info
	WHERE safety_group_footnote IS NOT NULL
		AND safety_group_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, 'readm_group' AS footnote_context,
		TRIM(unnest(string_to_array(readm_group_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_gen_info
	WHERE readm_group_footnote IS NOT NULL
		AND readm_group_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, 'pt_exp_group' AS footnote_context,
		TRIM(unnest(string_to_array(pt_exp_group_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_gen_info
	WHERE pt_exp_group_footnote IS NOT NULL
		AND pt_exp_group_footnote != ''
	
	UNION ALL
	
	SELECT facility_id, 'te_group' AS footnote_context,
		TRIM(unnest(string_to_array(te_group_footnote, ','))) AS footnote_id
	FROM staging.stg_hospital_gen_info
	WHERE te_group_footnote IS NOT NULL
		AND te_group_footnote != ''
	
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
		'core.hospital_info_footnote',
		v_rows_staged,
		v_rows_inserted, 
		v_rows_staged - v_rows_inserted, 
		'success',
		NULL
	);

	RAISE NOTICE 'load_hospital_info_footnote: % staged, % inserted, % skipped',
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
		'core.hospital_info_footnote',
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
CALL staging.load_hospital_info_footnote();

-- check the import_log
SELECT * FROM staging.import_log;

