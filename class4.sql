-- WHO Manages Helen Fleming?

SELECT fname, lname 
FROM employee 
WHERE emp_id = 

(SELECT superior_emp_id 
FROM employee
WHERE fname LIKE 'Helen' AND lname LIKE 'Fleming'); -- subquery

--Name managers
SELECT fname, lname
FROM employee
WHERE emp_id IN 
(SELECT superior_emp_id FROM employee);
-- We can use join as well, but this is more efficient
-- Select data within 1 table, subquery is always more efficient
-- IN does not care about duplicates
-- DISTINCT is a lot of extra work for SQL
-- IN does not care about NULL (null is not a value)


--WHO does not manage anyone
SELECT fname, lname
FROM employee
WHERE emp_id NOT IN 
(SELECT superior_emp_id FROM employee);

--NOT IN: != value1 AND != value2....


--WHO does not manage anyone
SELECT fname, lname
FROM employee
WHERE emp_id NOT IN 
(SELECT superior_emp_id FROM employee
WHERE superior_emp_id IS NOT NULL);


--Max balance for each product
SELECT product_cd, max(avail_balance)
FROM account
GROUP BY product_cd;


--Which account has the highest balance in checking
SELECT account_id
FROM account
WHERE avail_balance = 
(SELECT max(avail_balance) FROM account WHERE product_cd LIKE 'CHK')
AND product_cd LIKE 'CHK'; -- important



--Which account has the highest balance in each product

SELECT a.account_id, a.product_cd, MaxQuery.maxbal
FROM
account a JOIN 
(SELECT product_cd, max(avail_balance) maxbal
FROM account
GROUP BY product_cd) MaxQuery
ON a.product_cd = MaxQuery.product_cd
WHERE a.avail_balance = MaxQuery.maxbal;
-- Join a subquery


SELECT * FROM individual;
select * from business;

select *
from individual
union
select *
from business;  --captions from first table, works only if columns aligned,
--and may not be meaningful


SELECT cust_id, lname as name FROM individual
UNION
select cust_id, name from business;


--Add customer type
SELECT cust_id, lname as name, 'Individual' as "Customer Type" FROM individual
UNION
select cust_id, name, 'Business' from business;

--LEFT OUTER JOIN
select a.account_id, i.lname, b.name
from account a left outer join individual i on a.cust_id = i.cust_id
left outer join business b on a.cust_id = b.cust_id;

-- Decode
select a.account_id, decode(c.cust_type_cd, 'I', i.lname,b.name)
from account a join customer c on a.cust_id = c.cust_id
left outer join individual i on a.cust_id = i.cust_id
left outer join business b on a.cust_id = b.cust_id;
--assume either I or B


-- Case when
select a.account_id, 
   case
     when c.cust_type_cd = 'I'
        then i.lname
     when c.cust_type_cd = 'B'
        then b.name
     else
        'Unknown'
   end   name
   
from account a join customer c on a.cust_id = c.cust_id
left outer join individual i on a.cust_id = i.cust_id
left outer join business b on a.cust_id = b.cust_id;



-- Another case when example, classify customer tiers
select account_id, PRODUCT_CD,avail_balance,
   case
      when avail_balance <= 1000
      then 'Low'
      when avail_balance <= 10000
      then 'Medium'
      else
      'High'
    end tier
    
    from account;
    

--Create view, always replace view in case there's a previous view
create or replace view acc_tiers(id, product, balance, tier)
as (
select account_id, PRODUCT_CD,avail_balance,
   case
      when avail_balance <= 1000
      then 'Low'
      when avail_balance <= 10000
      then 'Medium'
      else
      'High'
    end tier
    
    from account);
    
-- Query view data
Select * FROM acc_tiers;


SELECT product, tier, SUM(balance) FROM acc_tiers
GROUP BY product, tier;


--subtotals
SELECT product, tier, SUM(balance) FROM acc_tiers
GROUP BY cube(product, tier);

--use decode for subtotals
select decode(grouping(PRODUCT),1,'All Products', product) product,
decode(grouping(tier),1,'All Tiers',Tier) tier, count(*) Count, to_char(trunc(sum(balance),-2),'$9,99,999') Balance
    from acc_tiers
    group by cube(tier, product);
 
 
-- classify tellers   
  select fname || '  ' || lname  name ,
        case
          when title = 'Head Teller'
             then 'Head Teller'
          when title = 'Teller' and to_char(start_date, 'YYYY') <= 2001
             then 'Experienced Teller'
          when title = 'Teller' and to_char(start_date, 'YYYY') >= 2003
             then 'Novice'
          else   'Teller'
        end  title,
        
        to_char(start_date, 'YYYY')
        
        from employee where title in('Teller', 'Head Teller');
        

-- reviewing results of query below shows some customers operate both checking and cd accounts.
select cust_id, product_cd
from account
where product_cd in ('CHK','CD')
order by cust_id;

--complicated way
SELECT chkquery.cust_id FROM
(SELECT cust_id FROM account
WHERE product_cd = 'CHK') chkquery
JOIN
(SELECT cust_id FROM account
WHERE product_cd = 'CD') cdquery
ON chkquery.cust_id = cdquery.cust_id;

-- INTERSECT
SELECT cust_id FROM
(SELECT cust_id FROM account
WHERE product_cd = 'CHK') 

INTERSECT

(SELECT cust_id FROM account
WHERE product_cd = 'CD');



