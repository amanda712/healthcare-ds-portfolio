-- ------------------------------------------------------------
-- Satisfaction vs. Star Rating Correlation 
-- ------------------------------------------------------------

/*
Join HCAHPS overall rating scores to the CMS overall star rating. 
*/


SELECT		hcahps.patient_survey_star_rating,
			ROUND(AVG(cms.overall_rating), 1) AS avg_overall_rating,
			COUNT(cms.facility_id) as number_of_facilities
FROM		core.dim_hospital_info AS cms
INNER JOIN	core.fact_survey_response AS hcahps ON cms.facility_id = hcahps.facility_id
WHERE		cms.overall_rating IS NOT NULL
			AND hcahps.patient_survey_star_rating IS NOT NULL
			AND hcahps.response_type = 'star_rating' 
			AND hcahps.measure_id = 'H_STAR_RATING'
GROUP BY	hcahps.patient_survey_star_rating;

