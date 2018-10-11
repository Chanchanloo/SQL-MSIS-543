-- show number of account per product and branch
-- for count(account_id) >2
-- excluding accounts opened at headquarters
-- account balance > 2000
SELECT p.name, b.name, count(account_id)
FROM account a join product p ON a.product_cd = p.product_cd
JOIN branch b ON a.open_branch_id = b.branch_id 
WHERE b.name NOT LIKE 'Headquarters'
    AND a.avail_balance > 2000
GROUP BY p.name, b.name
having count(account_id)>2;


--show account id, name of branch open at, and name of branch where
-- the employee who opened the account work at

SELECT a.account_id, b.name, eb.name AS "emp branch"
FROM account a JOIN branch b ON a.open_branch_id = b.branch_id 
    JOIN employee e ON a.open_emp_id = e.emp_id
    JOIN branch eb ON e.assigned_branch_id = eb.branch_id;
    
-- new nickname ensures we are joining with a different copy of the branch tabl
-- requred, in this case the opening branch name could be different from the employee branch name
-- sql, join work with one row at a time


-- employee lastname adn manage last names

SELECT emp.lname AS "employee", mgr.lname AS "manager"
FROM employee emp JOIN employee mgr ON emp.superior_emp_id = mgr.emp_id;
-- null is not equal to anything
-- nor is null not equal to anything
-- inner join only actual matches reported

-- Left outer join
-- include employees without managers
SELECT emp.lname AS "employee", mgr.lname AS "manager"
FROM employee emp LEFT OUTER JOIN employee mgr ON emp.superior_emp_id = mgr.emp_id;


-- right outer join
-- includes employees who do not manage anyone
SELECT emp.lname AS "employee", mgr.lname AS "manager"
FROM employee emp RIGHT OUTER JOIN employee mgr ON emp.superior_emp_id = mgr.emp_id;



--display total balance by each product and branch 
--(drilling down)
-- GROUP BY YEAR
select  product_cd, open_branch_id, to_char(open_date, 'YYYY')AS "year", sum(avail_balance)
from account
group by product_cd, open_branch_id, to_char(open_date, 'YYYY') 
ORDER BY to_char(open_date, 'YYYY') desc;

-- subtotal
select  product_cd, open_branch_id, to_char(open_date, 'YYYY')AS "year", sum(avail_balance)
from account
group by rollup(product_cd, open_branch_id, to_char(open_date, 'YYYY'));
--ORDER BY to_char(open_date, 'YYYY') desc;

-- to_char and rollup are specific to oracle.



-- using Decode to make above query’s results more readable
-- also rounds and formats the total balance
--illustrates double quotes for captions-as-typed
-- try also:  replace round with trunc

select 
to_char(open_date, 'YYYY') as Year ,
  decode(to_char(open_date, 'YYYY-Month'),null, 'All Months',to_char(open_date, 'YYYY-Month')) as Month ,
  decode(product_cd,null,'All Products', product_cd) as Product,
  decode(open_branch_id, null, 'All Branches', open_branch_id) as Branch,
  to_char(round(sum(avail_balance),-2),'$9,99,999.99') as "Total Balance"
from account
group by rollup(to_char(open_date, 'YYYY'),to_char(open_date, 'YYYY-Month'),product_cd, open_branch_id);

-- trunc(sum(avail_balance), -2)




select 
to_char(open_date, 'YYYY') as Year ,
  decode(to_char(open_date, 'YYYY-Month'),null, 'All Months',to_char(open_date, 'YYYY-Month')) as Month ,
  decode(product_cd,null,'All Products', product_cd) as Product,
  decode(open_branch_id, null, 'All Branches', open_branch_id) as Branch,
  to_char(round(sum(avail_balance),-2),'$9,99,999.99') as "Total Balance"
from account
group by cube(to_char(open_date, 'YYYY'),to_char(open_date, 'YYYY-Month'),product_cd, open_branch_id);
