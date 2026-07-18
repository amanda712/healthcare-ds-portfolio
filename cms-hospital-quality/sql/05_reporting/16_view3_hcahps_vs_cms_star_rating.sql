-- ------------------------------------------------------------
-- 16.HCAHPS vs CMS star rating
-- Comparison visual
-- Population: at least one of the two ratings exists
-- ------------------------------------------------------------


CREATE VIEW mart.vw_rating_comparison AS
WITH		
	hcahps_star_ratings
	AS			
	(
        SELECT	facility_id, patient_survey_star_rating
        FROM	core.fact_survey_response
        WHERE	measure_id = 'H_STAR_RATING' AND response_type = 'star_rating'				
	)
SELECT		cms.facility_id,
			hsr.patient_survey_star_rating,
			cms.overall_rating
FROM		core.dim_hospital_info cms
FULL JOIN	hcahps_star_ratings hsr ON cms.facility_id = hsr.facility_id
WHERE		(cms.overall_rating IS NOT NULL OR hsr.patient_survey_star_rating IS NOT NULL);
-- 3,308 rows


SELECT * FROM mart.vw_rating_comparison;
-- 3,308 rows