-- ------------------------------------------------------------
-- Data Quality Check
-- How many facilities have a non-null overall_rating in dim_hospital_info?
-- How many facilities have a non-null response_type of star_rating for H_HSP_RATING_STAR_RATING in fact_survey_response?
-- How many facilities have both?
-- How many facilities are in dim_hospital_info but have no matching rows at all in fact_survey_response?
-- ------------------------------------------------------------

WITH
    cms_overall_rating
    AS
    (
        SELECT	facility_id
        FROM	core.dim_hospital_info
        WHERE	overall_rating IS NOT NULL
    ),
    hcahps_star_rating
    AS
    (
        SELECT	facility_id
        FROM	core.fact_survey_response
        WHERE	measure_id = 'H_HSP_RATING_STAR_RATING' AND response_type = 'star_rating' AND patient_survey_star_rating IS NOT NULL
    ),
    facilities_w_both_ratings
    AS
    (
        SELECT		dhi.facility_id
        FROM		core.dim_hospital_info dhi
        FULL JOIN	core.fact_survey_response fsr
        ON			dhi.facility_id = fsr.facility_id
        WHERE		dhi.overall_rating IS NOT NULL AND 
					fsr.measure_id = 'H_HSP_RATING_STAR_RATING' AND fsr.response_type = 'star_rating' AND fsr.patient_survey_star_rating IS NOT NULL
    ),
	no_hcahps_facility
	AS
	(
		SELECT		DISTINCT(dhi.facility_id)
		FROM		core.dim_hospital_info dhi
		LEFT JOIN	core.fact_survey_response fsr ON dhi.facility_id = fsr.facility_id
		WHERE		fsr.facility_id IS NULL
	)
SELECT		COUNT(cor.facility_id) AS count_cms_overall_rating, 
			COUNT(hsr.facility_id) AS count_hcacps_star_rating,
			COUNT(fwbr.facility_id) AS count_both_ratings,
			COUNT(cor.facility_id) - COUNT(fwbr.facility_id) AS count_cms_only,
			COUNT(hsr.facility_id) - COUNT(fwbr.facility_id) AS count_hcahps_only,
			COUNT(nhf.facility_id) AS count_no_hcahps_participation
FROM		cms_overall_rating cor
FULL JOIN	hcahps_star_rating hsr ON cor.facility_id = hsr.facility_id
FULL JOIN   facilities_w_both_ratings fwbr ON cor.facility_id = fwbr.facility_id
FULL JOIN	no_hcahps_facility nhf ON cor.facility_id = nhf.facility_id;
