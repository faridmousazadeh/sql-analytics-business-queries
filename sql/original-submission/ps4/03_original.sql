-- famousaz
select
    item_id,
    item_name,
    item_type,
    item_reserve
from vb_items
where item_sold = 0
  and item_reserve >= 250
order by item_reserve DESC
