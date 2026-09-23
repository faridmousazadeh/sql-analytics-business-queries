/*
   IST 659 — SQL Analytics & Business Queries
   Portfolio version based on the supplied Problem Set 5 SQL.
   Run each numbered query separately in the course vBay database.
*/

-- 1. Item-type count and reserve-price summary.
WITH type_summary AS (
    SELECT item_type,
           COUNT(*) AS item_count,
           MIN(item_reserve) AS min_reserve,
           AVG(CAST(item_reserve AS decimal(12,2))) AS avg_reserve,
           MAX(item_reserve) AS max_reserve
    FROM vb_items
    GROUP BY item_type
)
SELECT COUNT(*) OVER () AS item_type_count,
       item_type, item_count, min_reserve, avg_reserve, max_reserve
FROM type_summary
ORDER BY item_type;
GO

-- 2. Item reserve compared with the mean, minimum, and maximum for its type.
SELECT item_name, item_type, item_reserve,
       MIN(item_reserve) OVER (PARTITION BY item_type) AS type_min_reserve,
       MAX(item_reserve) OVER (PARTITION BY item_type) AS type_max_reserve,
       AVG(CAST(item_reserve AS decimal(12,2)))
           OVER (PARTITION BY item_type) AS type_avg_reserve
FROM vb_items
WHERE item_type IN ('Antiques', 'Collectables')
ORDER BY item_type, item_name, item_id;
GO

-- 3. Average seller ratings received by each user with seller ratings.
-- INNER JOIN makes the output match the submitted WHERE filter semantics.
SELECT u.user_id, u.user_firstname, u.user_lastname,
       COUNT(*) AS rating_count,
       AVG(CAST(r.rating_value AS decimal(4,2))) AS avg_rating
FROM vb_users AS u
JOIN vb_user_ratings AS r
  ON r.rating_for_user_id = u.user_id
 AND r.rating_astype = 'Seller'
GROUP BY u.user_id, u.user_firstname, u.user_lastname
ORDER BY u.user_lastname, u.user_firstname, u.user_id;
GO

-- 4. Collectable items with more than one bid.
-- The assignment does not specify bid status, so this counts all bids.
-- Add AND b.bid_status = 'ok' in the join if only valid bids are intended.
SELECT i.item_id, i.item_name, COUNT(*) AS bid_count
FROM vb_items AS i
JOIN vb_bids AS b
  ON b.bid_item_id = i.item_id
WHERE i.item_type = 'Collectables'
GROUP BY i.item_id, i.item_name
HAVING COUNT(*) > 1
ORDER BY bid_count DESC, i.item_name, i.item_id;
GO

-- 5. Valid bid history for a selected item, oldest first.
DECLARE @item_id int = 11;
SELECT i.item_id, i.item_name,
       ROW_NUMBER() OVER (
           PARTITION BY i.item_id
           ORDER BY b.bid_datetime, b.bid_id
       ) AS bid_order,
       b.bid_amount,
       CONCAT(u.user_firstname, ' ', u.user_lastname) AS bidder
FROM vb_items AS i
JOIN vb_bids AS b
  ON b.bid_item_id = i.item_id
JOIN vb_users AS u
  ON u.user_id = b.bid_user_id
WHERE b.bid_status = 'ok'
  AND i.item_id = @item_id
ORDER BY b.bid_datetime, b.bid_id;
GO

-- 6. Previous and next bidder in the selected item's valid bid history.
DECLARE @item_id int = 11;
SELECT i.item_name,
       ROW_NUMBER() OVER (
           PARTITION BY i.item_id
           ORDER BY b.bid_datetime, b.bid_id
       ) AS bid_order,
       b.bid_amount,
       LAG(CONCAT(u.user_firstname, ' ', u.user_lastname)) OVER (
           PARTITION BY i.item_id
           ORDER BY b.bid_datetime, b.bid_id
       ) AS previous_bidder,
       CONCAT(u.user_firstname, ' ', u.user_lastname) AS bidder,
       LEAD(CONCAT(u.user_firstname, ' ', u.user_lastname)) OVER (
           PARTITION BY i.item_id
           ORDER BY b.bid_datetime, b.bid_id
       ) AS next_bidder
FROM vb_items AS i
JOIN vb_bids AS b
  ON b.bid_item_id = i.item_id
JOIN vb_users AS u
  ON u.user_id = b.bid_user_id
WHERE b.bid_status = 'ok'
  AND i.item_id = @item_id
ORDER BY b.bid_datetime, b.bid_id;
GO

-- 7. Users with more than one rating given and an average below the overall average.
WITH overall_average AS (
    SELECT AVG(CAST(rating_value AS decimal(4,2))) AS avg_rating
    FROM vb_user_ratings
), rater_summary AS (
    SELECT u.user_id, u.user_firstname, u.user_lastname, u.user_email,
           COUNT(*) AS rating_count,
           AVG(CAST(r.rating_value AS decimal(4,2))) AS avg_rating
    FROM vb_users AS u
    JOIN vb_user_ratings AS r
      ON r.rating_by_user_id = u.user_id
    GROUP BY u.user_id, u.user_firstname, u.user_lastname, u.user_email
)
SELECT s.user_id, s.user_firstname, s.user_lastname, s.user_email,
       s.rating_count, s.avg_rating, o.avg_rating AS overall_avg_rating
FROM rater_summary AS s
CROSS JOIN overall_average AS o
WHERE s.rating_count > 1
  AND s.avg_rating < o.avg_rating
ORDER BY s.avg_rating, s.user_lastname, s.user_firstname;
GO

-- 8. Bids-per-item KPI for each user with at least one valid bid.
SELECT u.user_id, u.user_firstname, u.user_lastname, u.user_email,
       COUNT(*) AS valid_bid_count,
       COUNT(DISTINCT b.bid_item_id) AS distinct_items_bid_on,
       CAST(COUNT(*) AS decimal(10,6))
           / COUNT(DISTINCT b.bid_item_id) AS bids_per_item
FROM vb_users AS u
JOIN vb_bids AS b
  ON b.bid_user_id = u.user_id
WHERE b.bid_status = 'ok'
GROUP BY u.user_id, u.user_firstname, u.user_lastname, u.user_email
ORDER BY bids_per_item DESC, u.user_lastname, u.user_firstname;
GO

-- 9. Highest valid bid on each unsold item.
-- The source PS4 query uses item_sold = 0 for unsold items; one winning row is shown.
-- Equal bid amounts are resolved by latest bid time, then bid_id.
WITH ranked_bids AS (
    SELECT i.item_id, i.item_name, b.bid_amount,
           CONCAT(u.user_firstname, ' ', u.user_lastname) AS bidder,
           ROW_NUMBER() OVER (
               PARTITION BY i.item_id
               ORDER BY b.bid_amount DESC, b.bid_datetime DESC, b.bid_id DESC
           ) AS bid_rank
    FROM vb_items AS i
    JOIN vb_bids AS b
      ON b.bid_item_id = i.item_id
    JOIN vb_users AS u
      ON u.user_id = b.bid_user_id
    WHERE i.item_sold = 0
      AND b.bid_status = 'ok'
)
SELECT item_id, item_name, bidder, bid_amount
FROM ranked_bids
WHERE bid_rank = 1
ORDER BY item_name, item_id;
GO

-- 10. Seller rating summary with overall average and the per-user difference.
WITH seller_ratings AS (
    SELECT rating_for_user_id, rating_value,
           AVG(CAST(rating_value AS decimal(4,2))) OVER () AS overall_avg
    FROM vb_user_ratings
    WHERE rating_astype = 'Seller'
)
SELECT u.user_id, u.user_firstname, u.user_lastname, u.user_email,
       COUNT(*) AS rating_count,
       AVG(CAST(r.rating_value AS decimal(4,2))) AS avg_rating,
       r.overall_avg,
       AVG(CAST(r.rating_value AS decimal(4,2))) - r.overall_avg
           AS rating_difference
FROM vb_users AS u
JOIN seller_ratings AS r
  ON r.rating_for_user_id = u.user_id
GROUP BY u.user_id, u.user_firstname, u.user_lastname, u.user_email,
         r.overall_avg
ORDER BY avg_rating DESC, u.user_lastname, u.user_firstname;
GO


