-- ------------------------------------------------------------
-- 17.Ratings by facility ownership type
-- Has both raw `hospital_ownership` and simplifed `ownership_type` for a drill hierarchy
-- Population: at least one of the two ratings exists
-- ------------------------------------------------------------


CREATE VIEW mart.vw_ownership_ratings AS
WITH		
	hcahps_star_ratings
	AS			
	(
        SELECT	facility_id, patient_survey_star_rating
        FROM	core.fact_survey_response
        WHERE	measure_id = 'H_STAR_RATING' AND response_type = 'star_rating'				
	)
SELECT		cms.facility_id,
			CASE
				WHEN hospital_ownership = 'Veterans Health Administration' OR hospital_ownership LIKE '%Government%' OR  hospital_ownership LIKE '%Defense%' THEN 'Government'
				WHEN hospital_ownership LIKE '%Voluntary%' THEN 'Non-Profit'
				WHEN hospital_ownership LIKE '%Proprietary' THEN 'For-Profit'
				ELSE 'Other'
			END AS ownership_type,
			cms.hospital_ownership,
			cms.overall_rating,
			hsr.patient_survey_star_rating
FROM		core.dim_hospital_info cms
FULL JOIN	hcahps_star_ratings hsr ON cms.facility_id = hsr.facility_id
WHERE		(cms.overall_rating IS NOT NULL OR hsr.patient_survey_star_rating IS NOT NULL);
-- 3,308 rows


SELECT * FROM mart.vw_ownership_ratings;
-- 3,308 rows