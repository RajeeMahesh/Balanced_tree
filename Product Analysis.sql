What are the top 3 products by total revenue before discount?
select product_name, sum(s.price) as tot_rev
from balanced_tree.sales s
join balanced_tree.product_details pd
on pd.product_id = s.prod_id
group by product_name 
order by tot_rev 
LIMIT 3 

