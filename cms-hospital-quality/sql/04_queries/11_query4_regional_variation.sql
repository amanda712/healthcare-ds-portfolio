-- ------------------------------------------------------------
-- Regional Variation
-- ------------------------------------------------------------

/*
Uses AVG() OVER (PARTITION BY state) to compute state-level averages alongside each hospital's score. 
Calculates each hospital's deviation from its state mean. 
*/


SELECT		cms.facility_id, 
			cms.facility_name, 
			cms.state,
			hcahps.hcahps_linear_mean_value AS facility_linear_mean,
			ROUND(AVG(hcahps.hcahps_linear_mean_value) OVER (PARTITION BY state), 1) AS state_avg_linear_mean,
			ROUND(hcahps.hcahps_linear_mean_value - (ROUND(AVG(hcahps.hcahps_linear_mean_value) OVER (PARTITION BY state), 1)), 1) AS facility_deviation_from_state_avg
FROM		core.dim_hospital_info AS cms
INNER JOIN	core.fact_survey_response AS hcahps ON cms.facility_id = hcahps.facility_id
WHERE		hcahps.hcahps_linear_mean_value IS NOT NULL
			AND hcahps.response_type = 'linear_mean' 
			AND hcahps.measure_id = 'H_HSP_RATING_LINEAR_SCORE';

