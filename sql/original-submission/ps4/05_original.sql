-- famousaz
select
    b.bid_id,
    u.user_firstname,
    u.user_lastname,
    u.user_email,
    b.bid_datetime,
    b.bid_amount
from vb_bids b
join vb_users u
    on b.bid_user_id = u.user_id
where b.bid_status = 'ok'
    and b.bid_item_id = 1
order by b.bid_datetime DESC
