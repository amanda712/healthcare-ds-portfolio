-- ------------------------------------------------------------
-- 14.Facility location + ratings
-- facility_id, name, address, city, state, zip, hospital_ownership, overall_rating
-- State → city → facility drill-down hierarchy
-- Population: any HCAHPS participation
-- ------------------------------------------------------------


CREATE VIEW mart.vw_geo_facility_ratings AS
SELECT	cms.facility_id, cms.facility_name, cms.address, cms.city, cms.state, cms.zip_code, cms.hospital_ownership, cms.overall_rating
FROM	core.dim_hospital_info cms
WHERE	EXISTS (
			SELECT 1
			FROM core.fact_survey_response hcahps
			WHERE hcahps.facility_id = cms.facility_id AND patient_survey_star_rating IS NOT NULL
		);
-- 3183 rows


SELECT * FROM mart.vw_geo_facility_ratings;
-- 3,183 rows
