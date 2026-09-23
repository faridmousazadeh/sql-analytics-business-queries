-- famousaz
select
    b.bid_datetime,
    u.user_firstname,
    u.user_lastname,
    u.user_email,
    u.user_id,
    i.item_name,
    i.item_id,
    b.bid_amount,
    b.bid_status
from vb_bids b
join vb_users u
    on b.bid_user_id = u.user_id
join vb_items i
    on b.bid_item_id = i.item_id
where not b.bid_status = 'ok'
order by
    u.user_lastname,
    u.user_firstname,
    b.bid_datetime
