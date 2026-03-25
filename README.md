# MovieLens / Netflix — dbt on Snowflake

Analytics engineering project that transforms MovieLens-style data in **Snowflake** using **dbt** (staging → dimensions → facts), with sources, tests, and snapshots.

## Tech stack

- **dbt** (Core) + **dbt-snowflake**
- **Snowflake** (warehouse, database, schemas)
- **Python 3.9+** (virtual environment)

## Repository layout

```
movielens-netflix_dbt/
├── netflix/                 # dbt project root
│   ├── dbt_project.yml
│   ├── profiles.yml         # local only — not committed (see Security)
│   ├── models/
│   │   ├── staging/         # sources → staging models
│   │   ├── dim/             # dimension tables
│   │   └── fact/            # fact tables (incl. incremental where used)
│   ├── snapshots/           # e.g. tag history
│   └── tests/singular/      # custom SQL tests
├── run_dbt.sh               # helper: activate venv + run dbt from netflix/
├── snowflake_*.sql          # optional Snowflake DDL / grants / clones
├── SETUP_COMMANDS.md        # copy-paste setup from scratch
└── venv/                    # create locally (not committed)
```

## Prerequisites

- Snowflake account with a warehouse, database, and role/user that dbt can use
- Python 3.9+ and `pip`

## Quick start

1. **Clone** this repo and `cd` into the project folder.

2. **Python environment**

   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install dbt-core dbt-snowflake
   ```

   If your default pip index fails, use public PyPI, for example:

   ```bash
   pip install dbt-core dbt-snowflake --index-url https://pypi.org/simple/
   ```

3. **Snowflake** — run the SQL in `snowflake_setup.sql` (and any clone/grant scripts you need) in a Snowflake worksheet as an admin role. Adjust names (warehouse, database, role, user) to match your environment.

4. **Profile** — copy `profiles.yml.example` to `netflix/profiles.yml` and set your Snowflake credentials and connection settings. Never commit real passwords.

5. **Run dbt** from the repository root:

   ```bash
   chmod +x run_dbt.sh
   bash run_dbt.sh debug
   bash run_dbt.sh run
   bash run_dbt.sh test
   bash run_dbt.sh snapshot
   ```

   Or manually:

   ```bash
   source venv/bin/activate
   cd netflix
   dbt run --profiles-dir .
   ```

## Documentation

- **`SETUP_COMMANDS.md`** — full local + Snowflake + troubleshooting steps.

## Security

- **`netflix/profiles.yml`** is listed in `.gitignore`. Keep secrets only in that file or in environment variables (e.g. `env_var` in profiles).
- Do not commit Snowflake passwords, private keys, or account identifiers in screenshots or public repos.

## License

Add a license if you publish this project publicly.
