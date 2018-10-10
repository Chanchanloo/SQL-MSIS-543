--1.   List  Department IDs and Number of Employees working at each.
SELECT dept_id, count(emp_id) FROM employee
GROUP BY dept_id;

-- 2.   List  products (CHK,CD etc)  and Number of Accounts, Highest and Lowest Available Balance for each.
--Use captions  NumAccounts, HiBal and LowBal.

SELECT product_cd, count(account_id) AS "NumAccounts", MAX(avail_balance) AS "Hibal", MIN(avail_balance) AS "LowBal"
FROM account
GROUP BY product_cd;


--3. List  Employee IDs and Number of Accounts Opened By Each.
SELECT open_emp_id, COUNT(account_id) FROM account
GROUP BY open_emp_id;

--4. List Employee IDs and Number of Accounts Opened by Each, by each Product. (CHK,MM etc).
SELECT open_emp_id, product_cd, count(*) FROM account
GROUP BY open_emp_id, product_cd
ORDER BY open_emp_id;

--5. List the Average Balance by Branch and Product. 
SELECT open_branch_id, product_cd, AVG(avail_balance) FROM account
GROUP BY open_branch_id, product_cd
ORDER BY open_branch_id;

--6. List Number of Accounts by Customer and Product.
SELECT cust_id, product_cd, count(account_id) FROM account
GROUP BY cust_id, product_cd
ORDER BY cust_id;


--7.  Show Employee Last Names, their Department Names and their Branch Names.
SELECT employee.LNAME, department.name, branch.name
FROM employee JOIN department ON department.dept_id = employee.dept_id
              JOIN branch ON branch_id = assigned_branch_id;

--8.  Show Account IDs,  Opening Employee’s Last Name, and name of Branch Account was opened at.
SELECT account_id, employee.LNAME, branch.name 
FROM account JOIN employee ON open_emp_id = emp_id
              JOIN branch ON branch_id = assigned_branch_id;
              
              
-- 9. Show  product names and product type descriptions for each. (product name  e.g  checking account)
SELECT product.name, product_type.name 
FROM product JOIN PRODUCT_TYPE ON product.PRODUCT_TYPE_cd = product_type.product_type_cd;



--10.  Show the Highest Balance by Product Name.
SELECT product.name, MAX(avail_balance)
FROM account JOIN product ON account.product_cd = product.product_cd
GROUP BY product.name;


--11.  Show the  Number of Accounts by Branch Name.
SELECT branch.name, count(account_id) 
FROM branch JOIN account ON branch_id = open_branch_id
GROUP BY branch.name;


--12. Show the Lowest Balance by Product Name and Employee Last Name.
SELECT e.lname, p.name, MIN(a.avail_balance)
FROM account a JOIN product p ON a.product_cd = p.product_cd
               JOIN employee e ON a.open_emp_id = e.emp_id
GROUP BY p.name, e.lname;

--13. Show the Number of Accounts by Product Name, Opening Branch Name, and Employee Last Name.
SELECT p.name, b.name, e.lname, COUNT(account_id)
FROM account a JOIN employee e ON open_emp_id = emp_id
               JOIN branch b ON open_branch_id = branch_id
               JOIN product p ON a.product_cd = p.product_cd
GROUP BY p.name, b.name, e.lname;
               


--14. Repeat same query, including subtotals for all combinations, and grand total. (cube)
SELECT p.name, b.name, e.lname, COUNT(account_id)
FROM account a JOIN employee e ON open_emp_id = emp_id
               JOIN branch b ON open_branch_id = branch_id
               JOIN product p ON a.product_cd = p.product_cd
GROUP BY cube(p.name, b.name, e.lname);
