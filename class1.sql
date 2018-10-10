SELECT LNAME, START_DATE 
FROM EMPLOYEE
ORDER BY LNAME DESC;
 -- sort is ascending by default
 -- can sort on numbers, strings, dates
 -- for dates, yesterday < today
 -- semicolon is a seperator
 
SELECT LNAME, START_DATE 
FROM EMPLOYEE
ORDER BY START_DATE;


SELECT LNAME AS "lastname", START_DATE AS "started on" -- double quotes for new defined names
FROM EMPLOYEE
WHERE title LIKE 'Teller';   -- like is for strings, in single quotes

SELECT LNAME AS "lastname", START_DATE AS "started on" 
FROM EMPLOYEE
WHERE title LIKE 'Teller' AND  START_DATE LIKE '%-02'
ORDER BY START_DATE DESC;

SELECT LNAME AS "lastname", START_DATE AS "started on" 
FROM EMPLOYEE
WHERE title LIKE 'Teller' AND  START_DATE LIKE '%-02'
AND LNAME LIKE '%er'
ORDER BY START_DATE DESC; --ORDER BY is always the last line

SELECT dept_id, COUNT(emp_id) FROM employee
GROUP BY dept_id;


SELECT dept_id, COUNT(emp_id), MIN(start_date), MAX(start_date) FROM employee
GROUP BY dept_id;


-- depts with  >1 employee
SELECT dept_id FROM employee
GROUP BY dept_id
HAVING COUNT(emp_id) > 1;


SELECT dept_id FROM employee
WHERE title LIKE 'Teller'
GROUP BY dept_id
HAVING COUNT(*) > 1;
-- * designate each row

SELECT * FROM department;

SELECT product_cd, SUM(avail_balance) FROM account
GROUP BY PRODUCT_CD;

SELECT product_cd, OPEN_BRANCH_ID, SUM(avail_balance) FROM account
GROUP BY PRODUCT_CD, OPEN_BRANCH_ID;

-- Drill down vs roll up


SELECT e.LNAME, d.NAME
FROM employee e JOIN department d 
ON e.dept_id = d.dept_id;

SELECT e.LNAME, d.NAME, b.name
FROM employee e 
JOIN department d 
    ON e.dept_id = d.dept_id
JOIN branch b
    ON e.assigned_branch_id = b.branch_id;



CREATE VIEW emp_full(name, department, branch)
AS

SELECT e.LNAME, d.NAME, b.name
FROM employee e 
JOIN department d 
    ON e.dept_id = d.dept_id
JOIN branch b
    ON e.assigned_branch_id = b.branch_id;
    
    
SELECT * FROM emp_full;
-- if the query is often used, it's better to store the view on disk
-- more efficient
-- materialized view
-- disadvantages: won't be up to date


--  show total balance by branch and product name
SELECT p.name, b.name, SUM(a.avail_balance)
FROM account a JOIN product p
ON a.product_cd = p.product_cd
JOIN branch b ON a.open_branch_id = b.branch_id
GROUP BY p.name, b.name;


-- select product_fat_content, store, sum(sales)
--from sales_fact join product_dim on sales_fact.product_key = product_dim.product_key
    -- join sotre_dim on sales_fact.store_key = store_dim.store_key
-- group by product_dim.product, sotre_dim.store; 



--show department names, branch names, and number of employees for each such combination

SELECT d.name, b.name, count(*)
FROM employee e JOIN department d ON e.dept_id = d.dept_id
JOIN branch b ON b.branch_id = e.assigned_branch_id
GROUP BY d.name, b.name;



