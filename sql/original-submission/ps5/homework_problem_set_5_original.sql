-- famousaz
select item_name, item_type, item_reserve, item_soldamount
 from vb_items
 where item_type = 'collectables'
 order by item_name
--1
-- famousaz 
select item_type,
       count(*) as item_count,
       min(item_reserve) as min_reserve,
       avg(item_reserve) as avg_reserve,
       max(item_reserve) as max_reserve
from vb_items
group by item_type
order by item_type 

--2
-- famousaz
select item_name,
       item_type,
       item_reserve,
       min(item_reserve) over (partition by item_type) as min_reserve,
       max(item_reserve) over (partition by item_type) as max_reserve,
       avg(item_reserve) over (partition by item_type) as avg_reserve
from vb_items
where item_type in ('Antiques', 'Collectables')
order by item_type, item_name 

--3
--famousaz
select u.user_firstname,
       u.user_lastname,
       count(*) as rating_count,
       avg(cast(r.rating_value as decimal(4,2))) as avg_rating
from vb_users u
left join vb_user_ratings r
    on r.rating_for_user_id = u.user_id
where r.rating_astype = 'Seller'
group by u.user_id, u.user_firstname, u.user_lastname
order by u.user_lastname, u.user_firstname 

--4
--famousaz
select i.item_name,
       count(*) as bid_count
from vb_items i
join vb_bids b
    on b.bid_item_id = i.item_id
where i.item_type = 'Collectables'
group by i.item_name
having count(*) > 1
order by bid_count desc 

--5
--famousaz
select i.item_id,
       i.item_name,
       row_number() over (
           partition by i.item_id
           order by b.bid_datetime
       ) as bid_order,
       b.bid_amount,
       u.user_firstname + ' ' + u.user_lastname as bidder
from vb_items i
join vb_bids b
    on b.bid_item_id = i.item_id
join vb_users u
    on u.user_id = b.bid_user_id
where b.bid_status = 'ok'
  and i.item_id = 11
order by b.bid_datetime  

-- 6
--famousaz
select i.item_name,
       row_number() over (
           partition by i.item_id
           order by b.bid_datetime
       ) as bid_order,
       b.bid_amount,
       lag(u.user_firstname + ' ' + u.user_lastname)
           over (
               partition by i.item_id
               order by b.bid_datetime
           ) as prev_bidder,
       u.user_firstname + ' ' + u.user_lastname as bidder,
       lead(u.user_firstname + ' ' + u.user_lastname)
           over (
               partition by i.item_id
               order by b.bid_datetime
           ) as next_bidder
from vb_items i
join vb_bids b
    on b.bid_item_id = i.item_id
join vb_users u
    on u.user_id = b.bid_user_id
where b.bid_status = 'ok'
  and i.item_id = 11
order by b.bid_datetime  

--7
--famousaz
with user_ratings as (
    select u.user_firstname,
           u.user_lastname,
           u.user_email,
           count(*) as rating_count,
           avg(cast(r.rating_value as decimal(4,2))) as avg_rating
    from vb_users u
    join vb_user_ratings r
        on r.rating_by_user_id = u.user_id
    group by u.user_id, u.user_firstname, u.user_lastname, u.user_email
)
select user_firstname,
       user_lastname,
       user_email
from user_ratings
where rating_count > 1
  and avg_rating < (select avg(cast(rating_value as decimal(4,2)))
 from vb_user_ratings) 

--8
--famousaz
select u.user_firstname,
       u.user_lastname,
       u.user_email,
       count(*) as bid_count,
       count(distinct b.bid_item_id) as item_count,
       cast(count(*) as decimal(10,6))
           / count(distinct b.bid_item_id) as bids_per_item
from vb_users u
join vb_bids b
    on b.bid_user_id = u.user_id
where b.bid_status = 'ok'
group by u.user_id,
         u.user_firstname,
         u.user_lastname,
         u.user_email
order by bids_per_item desc 

--9
--famousaz
with ranked_bids as (
    select i.item_name,
           b.bid_amount,
           u.user_firstname + ' ' + u.user_lastname as bidder,
           row_number() over (
               partition by i.item_id
               order by b.bid_amount desc
           ) as bid_rank
    from vb_items i
    join vb_bids b
        on b.bid_item_id = i.item_id
    join vb_users u
        on u.user_id = b.bid_user_id
    where i.item_soldamount is null
      and b.bid_status = 'ok'
)
select item_name,
       bidder,
       bid_amount
from ranked_bids
where bid_rank = 1
order by item_name 

--10
--famousaz
with seller_ratings as (
    select r.rating_for_user_id,
           r.rating_value,
           avg(cast(r.rating_value as decimal(4,2))) over () as overall_avg
    from vb_user_ratings r
    where r.rating_astype = 'Seller'
)
select u.user_firstname,
       u.user_lastname,
       u.user_email,
       count(*) as rating_count,
       avg(cast(r.rating_value as decimal(4,2))) as avg_rating,
       r.overall_avg,
       avg(cast(r.rating_value as decimal(4,2))) - r.overall_avg as rating_difference
from vb_users u
join seller_ratings r
    on r.rating_for_user_id = u.user_id
group by u.user_id,
         u.user_firstname,
         u.user_lastname,
         u.user_email,
         r.overall_avg 
