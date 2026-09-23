# SQL Analytics & Business Queries

This project presents vBay query work from IST 659 Problem Sets 4 and 5. It moves from SELECT, filtering, joins, and anti-joins to grouped analysis, CTEs, and window functions. The portfolio scripts retain the questions' business meaning while making key assumptions explicit and applying corrections recorded in the supplied PS5 feedback.

## Project contents

- **Problem Set 4:** customer and item lookups, seller/buyer reporting, bid review, and users/items with missing activity.
- **Problem Set 5:** reserve-price summaries, seller-rating analysis, bid histories, bidder activity measures, and highest-bid reporting.
- **Original submissions:** the supplied PS4 query files and PS5 SQL are preserved under `sql/original-submission/`.
- **Portfolio scripts:** edited and organized versions are under `sql/portfolio/`.

## Skills demonstrated

- SQL Server / T-SQL
- Filtering, sorting, `CASE`, and multi-table joins
- Self-joins for buyer and seller roles
- `GROUP BY`, `HAVING`, and aggregate functions
- CTEs and anti-joins with `NOT EXISTS`
- Window aggregates, `ROW_NUMBER()`, `LAG()`, and `LEAD()`
- KPI calculation with decimal division
- Translating business questions into query structure

## Run the scripts

The queries target the course vBay database (`vbay`) in Microsoft SQL Server. Provision that database in the IST 659 course environment before running the portfolio scripts. Run each query section independently; the PS5 script contains a selected example item ID (`11`) that can be changed for the bid-history questions.

No vBay database export or query-result screenshots are included. The project documents the SQL and its design choices without presenting unverified output as tested results.

## Repository structure

```text
sql-analytics-business-queries/
├── README.md
├── .gitignore
├── docs/
│   ├── query-design-notes.md
│   └── verification-notes.md
└── sql/
    ├── original-submission/
    │   ├── ps4/
    │   │   ├── 01_original.sql ... 10_original.sql
    │   └── ps5/
    │       └── homework_problem_set_5_original.sql
    └── portfolio/
        ├── 01_select_and_joins.sql
        └── 02_aggregation_ctes_and_windows.sql
```

## Companion project

[SQL Relational Database Design & Normalization](https://github.com/faridmousazadeh/sql-relational-database-design)

