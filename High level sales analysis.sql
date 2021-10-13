1.What was the total quantity sold for all products?

select product_id, product_name, sum(qty) as total_qty_purchased
from balanced_tree.product_details pd 
join balanced_tree.sales s 
on s.prod_id = pd.product_id 
group by product_id, product_name

2.What is the total generated revenue for all products before discounts?
select product_id, product_name, sum(s.price) as tot_rev
from balanced_tree.product_details pd 
join balanced_tree.sales s 
on pd.product_id = s.prod_id 
group by product_id, product_name
order by tot_rev desc

3. What was the total discount amount for all products?
select product_id, product_name, sum(discount) as tot_discounts
from balanced_tree.product_details pd 
join balanced_tree.sales s 
on pd.product_id = s.prod_id 
group by product_id, product_name
order by tot_discounts desc




