-- ------------------------------------------------------------
-- load_footnote
-- ------------------------------------------------------------

CREATE OR REPLACE PROCEDURE staging.load_footnote()
LANGUAGE plpgsql AS $$
-- set up variables to track data movement during the ETL process
DECLARE
	v_rows_staged	BIGINT;
	v_rows_inserted	INT;

BEGIN
	-- Count staged rows
	SELECT COUNT(*) INTO v_rows_staged FROM staging.stg_footnote_crosswalk;

-- Insert into production
WITH inserted AS (
	INSERT INTO core.footnote (
		footnote_id,
		footnote_text
	)
	SELECT
		footnote::VARCHAR(3),
		footnote_text::VARCHAR(230)
	FROM staging.stg_footnote_crosswalk
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
		'core.footnote',
		v_rows_staged,
		v_rows_inserted, 
		v_rows_staged - v_rows_inserted, 
		'success',
		NULL
	);

	RAISE NOTICE 'load_footnote: % staged, % inserted, % skipped',
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
		'core.footnote',
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
CALL staging.load_footnote();

-- check the import_log
SELECT * FROM staging.import_log;
