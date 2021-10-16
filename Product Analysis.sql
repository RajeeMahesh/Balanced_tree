1.What are the top 3 products by total revenue before discount?
select product_name, sum(s.price) as tot_rev
from balanced_tree.sales s
join balanced_tree.product_details pd
on pd.product_id = s.prod_id
group by product_name 
order by tot_rev 
LIMIT 3 

  product_name	                        tot_rev
  Teal Button Up Shirt - Mens	        USD 12420
  Cream Relaxed Jeans - Womens	        USD 12430
  Navy Oversized Jeans - Womens	        USD 16562
  

2.What is the total quantity, revenue and discount for each segment?
select *, (rev_earned - Discount_amt) as gain
from
    (select segment_name, sum(qty) as qty_sold, sum(s.price*qty) as rev_earned, sum((s.price*discount)/100) as Discount_amt 
    from balanced_tree.product_details pd 
    join balanced_tree.sales s 
    on pd.product_id = s.prod_id
    group by segment_name) t1
    
  segment_name	    qty_sold    	rev_earned    	discount_amt	gain
  Shirt	            11265	        135416	        14869	        120547
  Jeans	            11349       	68864         	6653        	62211
  Jacket	        11385       	121281        	12827       	108454
  Socks	            11217       	103729        	10764       	92965
  

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
    
  category_name     	qty_sold    	rev_earned    	discount_amt    	gain
    Mens              	22482       	714120        	25633           	688487
    Womens            	22734       	575333        	19480           	555853

                                 
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
select t_pg.segment_name, product_name, seg_gain, ((product_gain*100)/seg_gain) as per_rev
from
    (select segment_name, product_name, (rev_earned - Discount_amt) as product_gain
    from
        (select segment_name, product_name, sum(s.price*qty) as rev_earned, sum((s.price*discount)/100) as Discount_amt                                                     
        from balanced_tree.product_details pd 
        join balanced_tree.sales s 
        on pd.product_id = s.prod_id
        group by segment_name, product_name) t1) t_pg
join 
 	(select segment_name, (rev_earned - Discount_amt) as seg_gain
     from 
    (select segment_name, sum(s.price*qty) as rev_earned, sum((s.price*discount)/100) as Discount_amt                                                     
    from balanced_tree.product_details pd 
    join balanced_tree.sales s 
    on pd.product_id = s.prod_id
    group by segment_name) t2) t_sg
on t_pg.segment_name = t_sg.segment_name 
order by segment_name, per_rev desc

7.What is the percentage split of revenue by segment for each category?
select t_sg.category_name, segment_name, c_gain as category_gain, ((s_gain*100)/c_gain) as per_rev
from
    (select category_name, segment_name, (rev_earned - Discount_amt) as s_gain
    from
        (select category_name, segment_name, sum(s.price*qty) as rev_earned, sum((s.price*discount)/100) as Discount_amt
        from balanced_tree.product_details pd 
        join balanced_tree.sales s 
        on pd.product_id = s.prod_id
        group by category_name, segment_name) t2) t_sg
join 
    (select category_name, (rev_earned - Discount_amt) as c_gain
    from
        (select category_name, sum(qty) as qty_sold, sum(s.price*qty) as rev_earned, sum((s.price*discount)/100) as Discount_amt 
        from balanced_tree.product_details pd 
        join balanced_tree.sales s 
        on pd.product_id = s.prod_id
        group by category_name) t1) t_cg
on t_sg.category_name = t_cg.category_name
order by category_name, per_rev

category_name   	segment_name    	category_gain       	per_rev
Mens	            Socks              	688487              	43
Mens	            Shirt           	688487              	56
Womens	            Jeans           	555853              	36
Womens	            Jacket          	555853              	63

8.What is the percentage split of total revenue by category?
with tot as 
	(
    select (sum(price*qty) - sum((price*discount)/100)) as gain 
    from balanced_tree.sales)


select category_name, (rev_earned - Discount_amt) as c_gain, (((rev_earned - Discount_amt)*100)/(select * from tot)) as per_gain_in_tot_rev
from
        (select category_name, sum(qty) as qty_sold, sum(s.price*qty) as rev_earned, sum((s.price*discount)/100) as Discount_amt 
        from balanced_tree.product_details pd 
        join balanced_tree.sales s 
        on pd.product_id = s.prod_id
        group by category_name) t1
        
 category_name	        c_gain	        per_gain_in_tot_rev
    Mens            	688487          	55
    Womens          	555853          	44
   
9.What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)
select product_id, product_name, penetration_rate
from balanced_tree.product_details pd 
left join 
      (select prod_id, cast(count(txn_id) as numeric)/(select count(txn_id) from balanced_tree.sales) as penetration_rate
      from balanced_tree.sales s 
      group by prod_id) t_pr
on pd.product_id = t_pr.prod_id

10.What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?(developing in the answer)
select txn_id, string_agg(prod_id, ',' order by prod_id) as combo
from balanced_tree.sales
group by txn_id




                                         





