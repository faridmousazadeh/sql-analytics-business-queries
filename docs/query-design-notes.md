# Query design notes

## Problem Set 4

The portfolio queries use the vBay model to connect users, items, bids, ratings, and ZIP-code lookups. Buyer and seller roles use separate aliases on `vb_users`; the supplied vBay SQL names the buyer foreign key `item_buyer_user_id`. Queries for items with no bids use a `LEFT JOIN` and null check; the no-activity query uses separate `NOT EXISTS` predicates to avoid row multiplication.

The activity prompt uses **or**: a user is returned if they have never posted an item, never bought an item, or never placed a bid. The SQL preserves that meaning. The category query uses the stated reserve thresholds and excludes `All Other`.

## Problem Set 5

The analytics queries summarize reserve prices by item type, compare each reserve with type-level window statistics, rank bids, calculate previous/next bidders, and report bidder and seller-rating measures.

The source feedback identified several presentation or robustness improvements, reflected in the portfolio version:

- Q1 reports the number of item types explicitly and casts reserve values before averaging.
- Q3 uses an `INNER JOIN`, matching the source filter that excludes users without seller ratings.
- Q4 groups by item ID and name so equal item names remain separate. Because the prompt does not explicitly limit the count to valid bids, the portfolio query counts all bids and documents how to restrict it to `bid_status = 'ok'`.
- Q5/Q6 include `bid_id` as a secondary order key when timestamps tie.
- Q9 uses `item_sold = 0`, matching the supplied PS4 query for unsold items, and resolves equal top bids deterministically. Use `RANK()` instead if all tied top bids should appear.
- Q7 counts ratings given (`rating_by_user_id`); Q3 and Q10 summarize seller ratings received (`rating_for_user_id`).

## Source boundary

The original SQL is retained separately. Portfolio queries may improve grouping, ordering, and clarity while preserving the question's intent. They do not include course screenshots, Word submission forms, or a database export.



