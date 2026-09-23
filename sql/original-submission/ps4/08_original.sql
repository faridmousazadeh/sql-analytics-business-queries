-- famousaz
select
    b.user_firstname,
    b.user_lastname,
    f.user_firstname,
    f.user_lastname,
    r.rating_value,
    r.rating_comment
from vb_user_ratings r
join vb_users b
    on r.rating_by_user_id = b.user_id
join vb_users f
    on r.rating_for_user_id = f.user_id
where r.rating_astype = 'Seller'
