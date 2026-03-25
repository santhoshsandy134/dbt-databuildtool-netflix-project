-- =============================================================================
-- Fix: "Object does not exist" when dbt lists schemas in NETFLIX_MOVIE
-- Run as ACCOUNTADMIN in Snowflake. Run each block or the whole script.
-- =============================================================================

-- Ensure TRANSFORM can see and use the database and its schemas
USE ROLE ACCOUNTADMIN;

GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE TRANSFORM;
GRANT USAGE ON DATABASE NETFLIX_MOVIE TO ROLE TRANSFORM;

-- Grant on every schema (required for "list schemas" and for dbt to run)
GRANT USAGE ON SCHEMA NETFLIX_MOVIE.PUBLIC TO ROLE TRANSFORM;
GRANT USAGE ON SCHEMA NETFLIX_MOVIE.RAW TO ROLE TRANSFORM;

-- So dbt can create objects in RAW
GRANT CREATE TABLE ON SCHEMA NETFLIX_MOVIE.RAW TO ROLE TRANSFORM;
GRANT CREATE VIEW ON SCHEMA NETFLIX_MOVIE.RAW TO ROLE TRANSFORM;
GRANT CREATE STAGE ON SCHEMA NETFLIX_MOVIE.RAW TO ROLE TRANSFORM;
GRANT CREATE FILE FORMAT ON SCHEMA NETFLIX_MOVIE.RAW TO ROLE TRANSFORM;
GRANT CREATE SCHEMA ON DATABASE NETFLIX_MOVIE TO ROLE TRANSFORM;

-- Optional: if you want dbt to write to PUBLIC instead of RAW, also grant:
-- GRANT CREATE TABLE ON SCHEMA NETFLIX_MOVIE.PUBLIC TO ROLE TRANSFORM;
-- GRANT CREATE VIEW ON SCHEMA NETFLIX_MOVIE.PUBLIC TO ROLE TRANSFORM;

-- Verify: run as ACCOUNTADMIN, then switch context and test
-- USE ROLE TRANSFORM;
-- USE WAREHOUSE COMPUTE_WH;
-- SHOW SCHEMAS IN DATABASE NETFLIX_MOVIE;   -- should return rows
