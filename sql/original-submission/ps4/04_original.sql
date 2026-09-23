-- famousaz
select
    item_id,
    item_name,
    item_type,
    item_reserve,
    case
        when item_reserve >= 250 then 'High-priced item'
        when item_reserve <= 50 then 'Low-priced item'
        else 'Average-priced item'
    end as category
from vb_items
where not item_type = 'All Other'
