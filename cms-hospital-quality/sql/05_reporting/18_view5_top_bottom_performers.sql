-- ------------------------------------------------------------
-- 18.Top and Bottom Performers
-- Top/Bottom Performer based on `overall_rating` = 5 or 1
-- Includes `overall_rating` and HCAHPS linear mean score (chosen for ranking granularity)
-- Population: all facilities, nulls preserved
-- ------------------------------------------------------------


CREATE VIEW mart.vw_top_bottom_performers AS
WITH		
	hcahps_linear_mean
	AS			
	(
        SELECT	facility_id, hcahps_linear_mean_value
        FROM	core.fact_survey_response
        WHERE	response_type = 'linear_mean' AND measure_id = 'H_HSP_RATING_LINEAR_SCORE'				
	)
SELECT		cms.facility_id,
			CASE
				WHEN overall_rating = 5 THEN 'Top Performer'
				WHEN overall_rating = 1 THEN 'Bottom Performer'
				ELSE NULL
			END AS flag_top_bottom,
			cms.overall_rating,
			hsr.hcahps_linear_mean_value
FROM		core.dim_hospital_info cms
LEFT JOIN	hcahps_linear_mean hsr ON cms.facility_id = hsr.facility_id;
-- 5,426 rows (matches dim_hospital_info rows)


SELECT * FROM mart.vw_top_bottom_performers;
-- 5,426 rows

