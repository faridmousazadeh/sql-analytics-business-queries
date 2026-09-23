-- famousaz
select
    user_firstname,
    user_lastname,
    user_email,
    user_zip_code
from vb_users
where user_zip_code like '13%'
