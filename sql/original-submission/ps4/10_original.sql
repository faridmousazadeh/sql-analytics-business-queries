-- famousaz
select
    u.user_firstname,
    u.user_lastname,
    u.user_email
from vb_users u
left join vb_items s
    on u.user_id = s.item_seller_user_id
left join vb_items i
    on u.user_id = i.item_buyer_user_id
left join vb_bids b
    on u.user_id = b.bid_user_id
where s.item_id IS NULL
    or i.item_id IS NULL
    or b.bid_id IS NULL
