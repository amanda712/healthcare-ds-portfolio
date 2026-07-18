-- ------------------------------------------------------------
-- National Summary by Measure
-- ------------------------------------------------------------

/*
Average HCAHPS patient experience scores by measure category, ranked.
*/

SELECT		measure_id, 
			REPLACE(hcahps_question, ' - linear mean score', '') AS measure_label, 
			ROUND(AVG(hcahps_linear_mean_value),1) AS avg_linear_mean,
			PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY hcahps_linear_mean_value) AS median_linear_value,
			ROUND(STDDEV(hcahps_linear_mean_value),1) AS stddev
FROM		core.fact_survey_response
WHERE		response_type = 'linear_mean'
GROUP BY	measure_id, measure_label
ORDER BY	avg_linear_mean;

