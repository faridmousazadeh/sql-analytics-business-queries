-- famousaz
select
    u.user_firstname,
    u.user_lastname,
    u.user_email,
    z.zip_city,
    z.zip_state,
    z.zip_code
from vb_users u
join vb_zip_codes z
    on u.user_zip_code = z.zip_code
where z.zip_state = 'NY'
order by
    z.zip_city,
    u.user_lastname,
    u.user_firstname
