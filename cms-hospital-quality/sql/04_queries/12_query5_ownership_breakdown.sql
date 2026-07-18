-- ------------------------------------------------------------
-- Ownership Type Breakdown
-- ------------------------------------------------------------

/*
Compares average satisfaction and star ratings across ownership types: Government, Non-profit, For-profit. 
Uses CASE WHEN to simplify ownership categories.
*/


SELECT		CASE
				WHEN hospital_ownership = 'Veterans Health Administration' OR hospital_ownership LIKE '%Government%' OR  hospital_ownership LIKE '%Defense%' THEN 'Government'
				WHEN hospital_ownership LIKE '%Voluntary%' THEN 'Non-Profit'
				ELSE 'For-Profit'
			END AS ownership_type,
			ROUND(AVG(cms.overall_rating), 1) AS avg_overall_rating,
			ROUND(AVG(hcahps.hcahps_linear_mean_value), 1) AS avg_linear_mean,
			COUNT(cms.facility_id) AS number_of_facilities
FROM		core.dim_hospital_info AS cms
INNER JOIN	core.fact_survey_response AS hcahps ON cms.facility_id = hcahps.facility_id
WHERE		cms.overall_rating IS NOT NULL
			AND hcahps.hcahps_linear_mean_value IS NOT NULL
			AND hcahps.response_type = 'linear_mean'
			AND hcahps.measure_id = 'H_HSP_RATING_LINEAR_SCORE'
GROUP BY	ownership_type;

