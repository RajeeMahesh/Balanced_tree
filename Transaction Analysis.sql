1.How many unique transactions were there?
select count(distinct txn_id)
from balanced_tree.sales

2.What is the average unique products purchased in each transaction?
select round(avg(c),2) as avg_unique_prod_per_trans
from
  (select txn_id, count(distinct prod_id) as c
  from balanced_tree.sales
  group by txn_id) t1 

4.What is the average discount value per transaction?
select txn_id, round(avg(discount),2) as avg_disc
from balanced_tree.sales 
group by txn_id 
order by avg_disc desc

5.What is the percentage split of all transactions for members vs non-members?
select (case when member is TRUE then 'member'
			else 'Non Member' end) as member, 
(count(distinct txn_id)*100)/cast((select count(distinct txn_id) from balanced_tree.sales) as float) as trans_perc
from balanced_tree.sales 
group by member 

6.What is the average revenue for member transactions and non-member transactions?
select (case when member is TRUE then 'member'
        	 else 'non member' end) as member, 
      round((sum(revenue)/count(revenue)),2) as avg_revenue
from 
    (select member, sum(price)-discount as revenue
    from balanced_tree.sales 
    group by member, txn_id, discount
    order by member) t1
group by member


member	avg_revenue
false	159.12
true	159.96




