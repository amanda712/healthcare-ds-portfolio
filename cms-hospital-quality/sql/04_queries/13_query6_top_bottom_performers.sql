-- ------------------------------------------------------------
-- Top and Bottom Performers
-- ------------------------------------------------------------

/*
Uses a CTE to identify the top bottom performers on overall star rating and pulls their HCAHPS satisfaction scores. 
*/

WITH facilities AS (
	SELECT		cms.facility_id,
				cms.overall_rating,
				CASE
					WHEN cms.overall_rating = 1 THEN 'Bottom Performer'
					WHEN cms.overall_rating = 5 THEN 'Top Performer'
				END AS rank_performance
	FROM		core.dim_hospital_info AS cms
	WHERE		cms.overall_rating NOT IN (2, 3, 4)
),
linear_means AS (
	SELECT		hcahps.facility_id,
				hcahps.hcahps_linear_mean_value
	FROM		core.fact_survey_response AS hcahps
	WHERE		hcahps.hcahps_linear_mean_value IS NOT NULL
				AND hcahps.response_type = 'linear_mean' 
				AND hcahps.measure_id = 'H_HSP_RATING_LINEAR_SCORE'
)
SELECT		f.rank_performance, 
			ROUND(AVG(lm.hcahps_linear_mean_value), 1) as avg_hcahps_linear_mean,
			COUNT(f.rank_performance) AS facility_count
FROM		facilities AS f
JOIN		linear_means AS lm ON f.facility_id = lm.facility_id
GROUP BY 	f.rank_performance;

