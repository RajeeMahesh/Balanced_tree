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

5.

