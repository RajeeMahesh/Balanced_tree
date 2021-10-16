1.What are the top 3 products by total revenue before discount?
select product_name, sum(s.price) as tot_rev
from balanced_tree.sales s
join balanced_tree.product_details pd
on pd.product_id = s.prod_id
group by product_name 
order by tot_rev 
LIMIT 3 

2.What is the total quantity, revenue and discount for each segment?
select *, (rev_earned - Discount_amt) as gain
from
    (select segment_name, sum(qty) as qty_sold, sum(s.price*qty) as rev_earned, sum((s.price*discount)/100) as Discount_amt 
    from balanced_tree.product_details pd 
    join balanced_tree.sales s 
    on pd.product_id = s.prod_id
    group by segment_name) t1


3.What is the top selling product for each segment?
select segment_name, product_name, qty_pur
    from
        (select segment_name, product_name, sum(qty) as qty_pur, dense_rank() 
                                                            over(partition by segment_name
                                                                order by sum(qty) desc) as r                                                         
        from balanced_tree.product_details pd 
        join balanced_tree.sales s 
        on pd.product_id = s.prod_id
        group by segment_name, product_name
        ) t1
    where r = 1 

4.What is the total quantity, revenue and discount for each category?
select *, (rev_earned - Discount_amt) as gain
from
    (select category_name, sum(qty) as qty_sold, sum(s.price*qty) as rev_earned, sum((s.price*discount)/100) as Discount_amt 
    from balanced_tree.product_details pd 
    join balanced_tree.sales s 
    on pd.product_id = s.prod_id
    group by category_name) t1
                                 
5.What is the top selling product for each category? 
select category_name, product_name, qty_pur
    from
        (select category_name, product_name, sum(qty) as qty_pur, dense_rank() 
                                                            over(partition by category_name
                                                                order by sum(qty) desc) as r                                                         
        from balanced_tree.product_details pd 
        join balanced_tree.sales s 
        on pd.product_id = s.prod_id
        group by category_name, product_name
        ) t1
where r = 1   

6.What is the percentage split of revenue by product for each segment?
with seg as 
    (select (rev_earned - Discount_amt) as g
     from 
    (select segment_name, sum(s.price*qty) as rev_earned, sum((s.price*discount)/100) as Discount_amt,                                                      
    from balanced_tree.product_details pd 
    join balanced_tree.sales s 
    on pd.product_id = s.prod_id
    group by segment_name) t2 )
 


select segment_name, product_name, (rev_earned - Discount_amt)/(select * from seg) 
from
    (select segment_name, product_name, sum(s.price*qty) as rev_earned, sum((s.price*discount)/100) as Discount_amt,                                                      
    from balanced_tree.product_details pd 
    join balanced_tree.sales s 
    on pd.product_id = s.prod_id
    group by segment_name, product_name) t1


                                         





