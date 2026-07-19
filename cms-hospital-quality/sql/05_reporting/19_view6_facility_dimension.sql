-- ------------------------------------------------------------
-- 19.Facility dimension view
-- Dimension anchor
-- Includes facility location information, overall rating, and ownership type
-- Population: all facilities, nulls preserved
-- ------------------------------------------------------------


CREATE VIEW mart.vw_dim_facility AS
SELECT	cms.facility_id, 
		cms.facility_name, 
		cms.address, 
		cms.city, 
		cms.state, 
		cms.zip_code,
		cms.hospital_type,
		cms.hospital_ownership,
		CASE
			WHEN hospital_ownership = 'Veterans Health Administration' OR hospital_ownership LIKE '%Government%' OR  hospital_ownership LIKE '%Defense%' THEN 'Government'
			WHEN hospital_ownership LIKE '%Voluntary%' THEN 'Non-Profit'
			WHEN hospital_ownership LIKE '%Proprietary' THEN 'For-Profit'
			ELSE 'Other'
		END AS ownership_type		
FROM	core.dim_hospital_info cms;
-- 5,426 rows

SELECT * FROM mart.vw_dim_facility;
-- 5,426 rows


