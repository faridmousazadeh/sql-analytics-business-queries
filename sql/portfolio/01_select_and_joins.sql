/*
   IST 659 — SQL Analytics & Business Queries
   Portfolio version based on the supplied Problem Set 4 and 5 SQL.
   Run each numbered query separately in the course vBay database.
*/

-- 1. Users whose ZIP code begins with 13.
SELECT user_firstname, user_lastname, user_email, user_zip_code
FROM vb_users
WHERE user_zip_code LIKE '13%';
GO

-- 2. Users in New York, ordered by city and name.
SELECT u.user_firstname, u.user_lastname, u.user_email,
       z.zip_city, z.zip_state, z.zip_code
FROM vb_users AS u
JOIN vb_zip_codes AS z
  ON z.zip_code = u.user_zip_code
WHERE z.zip_state = 'NY'
ORDER BY z.zip_city, u.user_lastname, u.user_firstname;
GO

-- 3. Unsold items with a reserve of at least 250.
SELECT item_id, item_name, item_type, item_reserve
FROM vb_items
WHERE item_sold = 0
  AND item_reserve >= 250
ORDER BY item_reserve DESC, item_id;
GO

-- 4. Reserve-price categories, excluding the All Other item type.
SELECT item_id, item_name, item_type, item_reserve,
       CASE
           WHEN item_reserve >= 250 THEN 'High-priced item'
           WHEN item_reserve <= 50 THEN 'Low-priced item'
           ELSE 'Average-priced item'
       END AS reserve_category
FROM vb_items
WHERE item_type <> 'All Other'
ORDER BY item_type, item_reserve DESC, item_id;
GO

-- 5. Valid bids for a selected item, newest first.
DECLARE @item_id int = 1;
SELECT b.bid_id, u.user_firstname, u.user_lastname, u.user_email,
       b.bid_datetime, b.bid_amount
FROM vb_bids AS b
JOIN vb_users AS u
  ON u.user_id = b.bid_user_id
WHERE b.bid_status = 'ok'
  AND b.bid_item_id = @item_id
ORDER BY b.bid_datetime DESC, b.bid_id DESC;
GO

-- 6. Bids with a status other than ok for the security review.
SELECT b.bid_datetime, u.user_id, u.user_firstname, u.user_lastname,
       u.user_email, i.item_id, i.item_name, b.bid_amount, b.bid_status
FROM vb_bids AS b
JOIN vb_users AS u
  ON u.user_id = b.bid_user_id
JOIN vb_items AS i
  ON i.item_id = b.bid_item_id
WHERE b.bid_status <> 'ok'
ORDER BY u.user_lastname, u.user_firstname, b.bid_datetime, b.bid_id;
GO

-- 7. Items with no bids, including the seller's name.
SELECT i.item_id, i.item_name, i.item_type,
       u.user_firstname AS seller_firstname,
       u.user_lastname AS seller_lastname,
       i.item_reserve
FROM vb_items AS i
JOIN vb_users AS u
  ON u.user_id = i.item_seller_user_id
LEFT JOIN vb_bids AS b
  ON b.bid_item_id = i.item_id
WHERE b.bid_id IS NULL
ORDER BY i.item_id;
GO

-- 8. Seller ratings, showing both the rater and the rated seller.
SELECT rater.user_firstname AS rater_firstname,
       rater.user_lastname AS rater_lastname,
       seller.user_firstname AS seller_firstname,
       seller.user_lastname AS seller_lastname,
       r.rating_value, r.rating_comment
FROM vb_user_ratings AS r
JOIN vb_users AS rater
  ON rater.user_id = r.rating_by_user_id
JOIN vb_users AS seller
  ON seller.user_id = r.rating_for_user_id
WHERE r.rating_astype = 'Seller'
ORDER BY seller.user_lastname, seller.user_firstname,
         rater.user_lastname, rater.user_firstname;
GO

-- 9. Sold-item report with seller and buyer locations.
SELECT i.item_id, i.item_name, i.item_type, i.item_soldamount,
       seller.user_firstname AS seller_firstname,
       seller.user_lastname AS seller_lastname,
       seller_zip.zip_city AS seller_city,
       seller_zip.zip_state AS seller_state,
       buyer.user_firstname AS buyer_firstname,
       buyer.user_lastname AS buyer_lastname,
       buyer_zip.zip_city AS buyer_city,
       buyer_zip.zip_state AS buyer_state
FROM vb_items AS i
JOIN vb_users AS seller
  ON seller.user_id = i.item_seller_user_id
JOIN vb_zip_codes AS seller_zip
  ON seller_zip.zip_code = seller.user_zip_code
JOIN vb_users AS buyer
  ON buyer.user_id = i.item_buyer_user_id
JOIN vb_zip_codes AS buyer_zip
  ON buyer_zip.zip_code = buyer.user_zip_code
WHERE i.item_sold = 1
ORDER BY i.item_id;
GO

-- 10. Users missing at least one of the three activity types named in the prompt.
-- OR is intentional: a user qualifies if they never posted, never bought, or never bid.
SELECT u.user_id, u.user_firstname, u.user_lastname, u.user_email
FROM vb_users AS u
WHERE NOT EXISTS (
          SELECT 1 FROM vb_items AS posted
          WHERE posted.item_seller_user_id = u.user_id
      )
   OR NOT EXISTS (
          SELECT 1 FROM vb_items AS bought
          WHERE bought.item_buyer_user_id = u.user_id
      )
   OR NOT EXISTS (
          SELECT 1 FROM vb_bids AS placed
          WHERE placed.bid_user_id = u.user_id
      )
ORDER BY u.user_lastname, u.user_firstname, u.user_id;
GO


