High Level Sales Analysis

1.What was the total quantity sold for all products?

select product_id, product_name, sum(qty) as total_qty_purchased
from balanced_tree.product_details pd 
join balanced_tree.sales s 
on s.prod_id = pd.product_id 
group by product_id, product_name

