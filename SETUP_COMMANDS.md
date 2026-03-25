# Setup commands – from start to finish

Use this file to set up the project from scratch. Run steps in order.

---

## 1. Local setup (terminal)

From the project root: `movielens-netflix_dbt` (or your project folder).

```bash
# Go to project root
cd /Users/st20/Documents/movielens-netflix_dbt

# Create Python virtual environment
python3 -m venv venv

# Activate venv
source venv/bin/activate

# Install dbt and Snowflake adapter (use public PyPI if your pip uses a private index)
pip install dbt-core dbt-snowflake --index-url https://pypi.org/simple/

# Check install
dbt --version
```

---

## 2. Snowflake setup (run in Snowflake Worksheets as ACCOUNTADMIN)

Copy the whole block below and run it in Snowflake.

```sql
-- Warehouse
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH
  WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- Role and dbt user
CREATE ROLE IF NOT EXISTS TRANSFORM;

CREATE USER IF NOT EXISTS dbt
  PASSWORD = 'dbtPassword123'
  LOGIN_NAME = 'dbt'
  MUST_CHANGE_PASSWORD = FALSE
  DEFAULT_WAREHOUSE = 'COMPUTE_WH'
  DEFAULT_ROLE = 'TRANSFORM'
  DEFAULT_NAMESPACE = 'NETFLIX_MOVIE.RAW'
  COMMENT = 'DBT user used for data transformation';

ALTER USER dbt SET TYPE = LEGACY_SERVICE;
GRANT ROLE TRANSFORM TO USER dbt;

-- Database and schema
USE WAREHOUSE COMPUTE_WH;
CREATE DATABASE IF NOT EXISTS NETFLIX_MOVIE;
USE DATABASE NETFLIX_MOVIE;
CREATE SCHEMA IF NOT EXISTS RAW;

-- Grants for TRANSFORM (so dbt can connect and build)
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE TRANSFORM;
GRANT USAGE ON DATABASE NETFLIX_MOVIE TO ROLE TRANSFORM;
GRANT USAGE ON SCHEMA NETFLIX_MOVIE.PUBLIC TO ROLE TRANSFORM;
GRANT USAGE ON SCHEMA NETFLIX_MOVIE.RAW TO ROLE TRANSFORM;
GRANT CREATE SCHEMA ON DATABASE NETFLIX_MOVIE TO ROLE TRANSFORM;
GRANT CREATE TABLE ON SCHEMA NETFLIX_MOVIE.RAW TO ROLE TRANSFORM;
GRANT CREATE VIEW ON SCHEMA NETFLIX_MOVIE.RAW TO ROLE TRANSFORM;
GRANT CREATE STAGE ON SCHEMA NETFLIX_MOVIE.RAW TO ROLE TRANSFORM;
GRANT CREATE FILE FORMAT ON SCHEMA NETFLIX_MOVIE.RAW TO ROLE TRANSFORM;
```

---

## 3. dbt profile

Profile is already in the repo at `netflix/profiles.yml` (and template at `profiles.yml.example`). It uses:

- Account: `MRLLBLD-IJ42733`
- User: `dbt`
- Role: `TRANSFORM`
- Database: `NETFLIX_MOVIE`
- Schema: `RAW`
- Warehouse: `COMPUTE_WH`

No extra commands needed unless you change credentials.

---

## 4. Run dbt (every time)

From project root:

```bash
cd /Users/st20/Documents/movielens-netflix_dbt

# Option A: use the run script (recommended)
bash run_dbt.sh debug    # test connection
bash run_dbt.sh run     # build models

# Option B: run dbt manually
source venv/bin/activate
cd netflix
dbt debug --profiles-dir .
dbt run --profiles-dir .
```

---

<!-- ## 5. If you see "Object does not exist" (permissions)

Run this in Snowflake as **ACCOUNTADMIN**:

```sql
USE ROLE ACCOUNTADMIN;

GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE TRANSFORM;
GRANT USAGE ON DATABASE NETFLIX_MOVIE TO ROLE TRANSFORM;
GRANT USAGE ON SCHEMA NETFLIX_MOVIE.PUBLIC TO ROLE TRANSFORM;
GRANT USAGE ON SCHEMA NETFLIX_MOVIE.RAW TO ROLE TRANSFORM;
GRANT CREATE TABLE ON SCHEMA NETFLIX_MOVIE.RAW TO ROLE TRANSFORM;
GRANT CREATE VIEW ON SCHEMA NETFLIX_MOVIE.RAW TO ROLE TRANSFORM;
GRANT CREATE STAGE ON SCHEMA NETFLIX_MOVIE.RAW TO ROLE TRANSFORM;
GRANT CREATE FILE FORMAT ON SCHEMA NETFLIX_MOVIE.RAW TO ROLE TRANSFORM;
GRANT CREATE SCHEMA ON DATABASE NETFLIX_MOVIE TO ROLE TRANSFORM;
```

Then run `bash run_dbt.sh run` again.

---

## Quick reference

| What              | Where / Command |
|------------------|-----------------|
| Project root     | `/Users/st20/Documents/movielens-netflix_dbt` |
| dbt project      | `netflix/` (has `dbt_project.yml`, `profiles.yml`, `models/`) |
| Snowflake SQL    | `snowflake_setup.sql`, `snowflake_fix_permissions.sql` |
| Run dbt          | `bash run_dbt.sh run` from project root | -->
