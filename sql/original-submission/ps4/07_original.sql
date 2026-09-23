-- famousaz
select
    i.item_id,
    i.item_name,
    i.item_type,
    u.user_firstname,
    u.user_lastname,
    i.item_reserve
from vb_items i
left join vb_bids b
    on i.item_id = b.bid_item_id
join vb_users u
    on i.item_seller_user_id = u.user_id
where b.bid_id IS NULL
