-- famousaz
select
    i.item_id,
    i.item_name,
    i.item_type,
    i.item_soldamount,
    s.user_firstname,
    s.user_lastname,
    sz.zip_city,
    sz.zip_state,
    b.user_firstname,
    b.user_lastname,
    bz.zip_city,
    bz.zip_state
from vb_items i
join vb_users s
    on i.item_seller_user_id = s.user_id
join vb_users b
    on i.item_buyer_user_id = b.user_id
join vb_zip_codes sz
    on s.user_zip_code = sz.zip_code
join vb_zip_codes bz
    on b.user_zip_code = bz.zip_code
where i.item_sold = 1
