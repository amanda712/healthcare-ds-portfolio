-- ------------------------------------------------------------
-- 15.Per-measure star ratings
-- Long format
-- 8 individual HCAHPS measures + summary (`H_STAR_RATING`)
-- Feeds map detail/tooltips
-- Population: star ratings only, nulls preserved
-- ------------------------------------------------------------


CREATE VIEW mart.vw_hcahps_star_ratings AS
SELECT		facility_id, measure_id, replace(hcahps_question::text, ' - star rating'::text, ''::text) AS measure_label,
			patient_survey_star_rating
FROM		core.fact_survey_response
WHERE		response_type::text = 'star_rating'::text
ORDER BY	facility_id;
-- 43,101 rows


SELECT * FROM mart.vw_hcahps_star_ratings;
-- 43,101 rows
