-- =============================================================================
-- Grant TRANSFORM (dbt) permission to READ tables in PUBLIC schema
-- Run as ACCOUNTADMIN in Snowflake.
-- =============================================================================

USE ROLE ACCOUNTADMIN;

-- Grant SELECT on existing tables in PUBLIC (so dbt can read MOVIES, RATINGS, etc.)
GRANT SELECT ON ALL TABLES IN SCHEMA NETFLIX_MOVIE.PUBLIC TO ROLE TRANSFORM;

-- So any new tables added to PUBLIC later are also readable by dbt
GRANT SELECT ON FUTURE TABLES IN SCHEMA NETFLIX_MOVIE.PUBLIC TO ROLE TRANSFORM;
