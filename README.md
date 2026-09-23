# SQL Analytics & Business Queries

## Overview

This repository contains SQL Server analytics and business-query coursework for IST 659. The vBay exercises progress from filtering, joins, and reporting queries to aggregation, CTEs, and window-function analysis.

The repository separates the original coursework SQL from curated portfolio scripts. The portfolio scripts consolidate and format the coursework queries and include selected documented query adjustments for presentation and analysis.

## Course

**IST 659 — Data Administration Concepts and Database Management**  
Syracuse University

## Objectives

- Use SQL queries to answer reporting and analysis questions about vBay users, items, bids, ratings, and locations.
- Apply filtering, joins, grouping, and aggregation to organize query results.
- Analyze bid histories, user activity, and seller ratings using CTEs and window functions.
- Make query assumptions and portfolio adjustments visible to readers.

## Technical Skills

- SQL Server / T-SQL
- Relational query design
- Filtering, sorting, and multi-table joins
- Self-joins for roles such as buyer, seller, rater, and rated user
- Aggregation with `GROUP BY` and `HAVING`
- CTEs, scalar subqueries, and anti-join patterns
- Window aggregates, `ROW_NUMBER()`, `LAG()`, and `LEAD()`
- `COUNT(DISTINCT)` and decimal-based ratio calculations
- Query parameterization with T-SQL variables
- Explicit ordering and tie-breakers for query presentation

## Analytical / Database Concepts

The queries use the vBay course database tables for users, items, bids, ratings, and ZIP-code information. They demonstrate reporting and analysis across related records, including user roles, item activity, bid status, seller feedback, and location details.

## Business Questions and Query Categories

### Problem Set 4

The original and portfolio queries cover:

- Users whose ZIP code begins with a specified prefix and users located in New York
- Unsold items above a reserve-price threshold and reserve-price categories
- Bid history for a selected item and bids with a non-`ok` status
- Items with no bids and sold-item reports with buyer, seller, and location details
- Seller-rating records
- Users missing **any one** of posting, buying, or bidding activity

The missing-activity query uses an OR interpretation: a user qualifies if they have never posted an item, never bought an item, or never placed a bid. It does not mean the user performed none of those activities.

### Problem Set 5

The original and portfolio queries cover:

- Item counts and reserve-price summaries by type
- Item reserve prices compared with type-level statistics
- Seller-rating summaries
- Bid counts for collectable items
- Chronological bid histories and previous/next bidder analysis
- Users with multiple ratings given and averages below an overall average
- Valid bids per bidder and bids-per-item ratios
- Highest valid bids for unsold items
- Seller-rating averages compared with an overall seller-rating average

The query-design notes document assignment-specific choices, including counting all bids for the collectable-item question where the prompt does not specify bid status.

## Key SQL Techniques

The repository demonstrates:

- Inner joins, multi-table joins, self-joins, and role aliases
- Filtering, sorting, and `CASE` expressions
- `LEFT JOIN` / `IS NULL` anti-join patterns in the original coursework
- Correlated `NOT EXISTS` anti-joins in the PS4 portfolio script
- Aggregates with `GROUP BY` and `HAVING`
- CTEs and a scalar subquery
- Window aggregates and `COUNT(DISTINCT)`
- `ROW_NUMBER()`, `LAG()`, and `LEAD()`
- `CONCAT` in the portfolio bid-history queries
- Decimal casts for averages and ratio calculations
- Ordering by date/time and additional keys to make tied bid ordering explicit

## Project Structure

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

## Data / Execution Context

The queries target the vBay database used in the IST 659 course environment and are written for Microsoft SQL Server. The database is not included in this repository. The portfolio PS4 bid query declares an item ID of `1`; the PS5 bid-history examples use item ID `11`.

## Source Integrity and Provenance

The files under `sql/original-submission/` preserve the coursework SQL. The files under `sql/portfolio/` are curated versions of the coursework queries. The two sets are intentionally kept separate.

The portfolio scripts consolidate and format the coursework queries and may include presentation, parameterization, deterministic ordering, or documented query-logic adjustments. The query-design notes describe these decisions. Material query differences are documented rather than hidden.

One material difference is PS5 Q9:

- **Original:** filters with `item_soldamount IS NULL`.
- **Portfolio:** filters with `item_sold = 0`.
- The portfolio version follows the supplied PS4 interpretation for unsold items. The repository does not establish that these predicates are equivalent; equivalence was not runtime-verified because the vBay database and query results are not included.

The PS4 missing-activity query retains the documented **any one** interpretation described above.

## Verification / Limitations

The vBay database is not included. The repository contains no runtime query outputs or screenshots, and no execution plans or benchmark measurements. The verification notes state that the queries were not executed in the audit workspace because the course database was unavailable. This README does not claim runtime verification, empirically verified query correctness, or measured performance improvement.

## Key Takeaways

This coursework demonstrates progression from foundational reporting queries to grouped analysis and window-function techniques using the vBay course database. Original SQL is preserved alongside curated scripts that make selected assumptions and query adjustments easier to review.

## Course Context

This repository presents SQL analytics and business-query coursework from **IST 659 — Data Administration Concepts and Database Management** at Syracuse University, covering Problem Sets 4 and 5.
