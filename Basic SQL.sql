## Limits
SELECT occurred_at, accound_id, channel
FROM web_events
LIMIT 15;


## Orderby /*Always go with From commond*/
SELECT *
FROM orders
ORDER BY occurred_at
LIMIT 1000;

/*
ORDER BY default is ascending. Add DESC in the ending to converse the orders
*/
SELECT *
FROM orders
ORDER BY occurred_at DESC
LIMIT 1000;

/*
ORDER BY 多个列表：会从左侧按序进行排列
*/
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;


## WHERE
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000  /*Before LIMIT and ORDER BY*/
LIMIT 5;

/*
WHERE with Non-Numeric Data, requires single-quotes, sensitive to captical letter
*/
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

## Arithmetic Operator
SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;

SELECT id, account_id,
   poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per
FROM orders
LIMIT 10;






######Logical Operators: LIKE, IN, NOT, AND&BETWEEN, OR
##LIKE
SELECT name
FROM accounts
WHERE name LIKE 'C%';

SELECT name
FROM accounts
WHERE name LIKE '%one%';

SELECT name
FROM accounts
WHERE name LIKE '%s';

##IN
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

##NOT /*Excluded to LIKE and IN*/
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%';

##And&BETWEEN
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s'; /* And 可以和其他logical operators连用*/

SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29; /*Between，the endpoint values are included*/

/*
BETWEEN用在date上有一点tricky，下例是要包含所有2016年的日期，右端应该是2017-1-1，因为It assumes the time is at 00:00:00
*/
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

##OR
SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
           AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') /*一个完整的指令要加括号*/
           AND primary_poc NOT LIKE '%eana%');

## DISTINCT
SELECT distinct department_id  /*Distinct can remove repeate values*/
From employees

## DESC
DESC table /*To see the table details and data type*/
describe table






###### String, Number, and Data Function
##SUBSTRING /*To interact number in a fit size*/
SELECT substr(job_title,1,15) FROM jobs

SELECT SUBSTR DISTINCT zip, SUBSTR(zip,1,3), SUBSTR(zip,-3,2) FROM customers;
/*Result:
Zip 98115, SUBSTR(zip,1,3) 981,  SUBSTR(zip,-3,2) 11
Zip 12211, SUBSTR(zip,1,3) 122,  SUBSTR(zip,-3,2) 21*/

##TRUNC /*To round numerica values in a fit size，but it will not round up or down*/
SELECT trunc(999.98765,3) /* Result would be 999.987. Moreover, it can be used in numerical column*/
FROM dual

##MOD /*求余函数*/
##ABS/*Absolute values*/
##LENGTH /*Count how many characters make up the value*/
SELECT first_name, last_name, length(first_name)

##CONCAT /*Combine with two values*/
SELECT CONCAT('First name: ', first_name), CONCAT('Last name: ', last_name)
FROM employees
##||/*Same as CONCAT, but it can combine with values as much as you want*/
SELECT 'First name: ' || first_name||'Last name: '|| last_name
FROM employees

##INSTR /*Return the postion of the specific number*/
SELECT phone_number, instr(phone_number, '6')
FROM employees

##RPAD and LPAD /*Pading string with a specific size*/
SELECT RPAD(first_name,10,'$') FROM employees

##TO_CHAR to convert numbers to string
SELECT TO_CHAR(salary,'L99G999') /*L means symbol$. Its result would be $24,000*/
FROM employees

##Format DATE values
SELECT first_name, TO_CHAR(hire_date, 'DD/MM/YYYY') /*MON in DD/MON/YYYY represents the month name */
FROM employees

##FIlter DATE values
SELECT first_name, hire_date FROM employees
WHERE TO_CHAR(hire_date, 'MON') ='JAN'

##Using SYSDATE and SYSTIMESTAMP
SELECT TO_CHAR(SYSDATE,'DD-MM-YY HH24:MI:SS') /* This is 24-hour format*/
FROM dual
/*SYSTIMESTAMP is more precise*/

##MONTHS_BETWEEN /*Calculate how many month between date*/
SELECT round(MONTHS_BETWEEN(SYSDATE, hire_date),0) /*If you want to calculate years, just divided 12.*/
FROM employees

##ADD_MONTH
SELECT SYSDATE, ADD_MONTH(SYSDATE,1), ADD_MONTH(SYSDATE,2),ADD_MONTH(SYSDATE,3) /*Result: 16-OCT-17, 16-NOV-17, 16-DEC-17, 16-JAN-18*/
FROM dual






#######JOIN TABLES
SELECT employees.first_name, employees.last_name, departments.department_name
FROM employees JOIN departments ON employees.department_id=departments.department_id /*The same as Inner Join*/

##Using WHERE to JOIN TABLES
SELECT c.firstname, c.lastname, o.order#, o.orderdate
FROM customers c, orders o
WHERE c.customer#=o.customer#
AND o.shipdate IS NOT NULL;

##Left JOIN /*Return all records from left table*/
SELECT c.firstname, c.lastname, o.order#, o.orderdate
FROM customers c Left JOIN orders o Using(customer#) ;

##RIGHT JOIN
##FULL JOIN

##Joins with table aliases
ELECT employees.first_name, employees.last_name, departments.department_name
FROM employees emp JOIN departments dept ON emp.department_id=dept.department_id


##Equality Joins
SELECT b.title, b.pubid, p.name
FROM publisher2 p JOIN books b
ON p.id=b.pubid;

##Not-Equality Joins
SELECT b.title, p.gift
FROM books b, promotion p
WHERE b.retail BETWEEN p.minretail AND p.maxratail;

##Self-Joins
/*Where to use it?
For example: Customers referred other customers.We need to connect the column "customer#" and "referred" in the table*/
SELECT r.firstname, r.lastname, c.lastname "Referred"
FROM customers c JOIN customers r
ON c.referred=r.customer#;



###### Manipulating data

##CREATE TABLE
CREATE TABLE test_table (col1 VARCHAR(100), col2 NUMBER(5))

##INSERT INTO
INSERT INTO test_table VALUES ('World',5) #如果插入的values可以和column一一对应，可以省略column名字

##COMMIT and ROLLBACK
ROLLBACK /*Undoing the end state of the transaction*/
COMMIT /*Commit makes the end state of the transaction persistent, and any subsequent commit or rollback commands would only apply to changes that have been to the data base in the subsequent transaction*/
/*ps.
1.If these has multiple-statement transactions, like Insert, delete and update, commit and rollback will be effect to all transactions
2.DDL commonds will automatically commit transactions.*/

##DELETE the table content
DELETE FROM test_table /*empty table, only keeps the column names*/
DELETE FROM test_table WHERE col1='hello' and col2=10/*delete specific content, WHERE clause determines which rows are removed*/
ROLLBACK /*If you delete sth by accident, rollback can undo it*/
##TRUNCATE
TRUNCATE TABLE test_table /*Empty the table. The differences with delete are it is faster when processes a large databse and it cannot be ROLLBACK because it is DDL commond */

##UPDATE
UPDATE test_table SET col1='Updated value!' WHERE col2 = 11 /*multiple columns can be updated in the same time only if add them after SET.*/

##Adding and dropping columns from a table
ALTER TABLE test_table ADD(col3 NUMBER(10))

SELECT * FROM test_table

INSERT INTO test_table VALUES ('hello',1,2);

ALTER TABLE test_table DROP COLUMN col3;





######Grouping data
##Using aggregate functions
SELECT MAX(salary), MIN(salary),avg(salary)
FROM employees;

SELECT COUNT(*)
FROM departments;

SELECT SUM(salary)
FROM employees;


##Using GROUP BY
SELECT COUNT(*) AS NUM_EMPLOYEES, department_id
FROM employees
GROUP BY department_id
ORDER BY NUM_EMPLOYEES DESC;

##GROUP BY with MAX, MIN, AVG
SELECT ROUND(AVG(salary)), department_id
FROM employees
GROUP BY department_id;

##Using HAVING /*A fliter of group by*/
SELECT ROUND(AVG(salary)), MAX(salary), department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary)>9000 AND MAX(salary)<15000;







######Advanced Topics
##Primary keys
CREATE TABLE demo_table2(col NUMBER(5) PRIMARY KEY, col2 VARCHAR2（20)）

##NOT NULL constraints /* Not null enforces that values have to be inserted into a specific column in the table. */

##CHECK constraints /*Check whether the input value meets the constraint*/
CREATE TABLE demo_table_NEW
(ID NUMBER(4), name VARCHAR2(50),
CONSTRAINT check_uppercase_name
CHECK(name=upper(name))
);


##FOREIGN KEY constraints

CREATE TABLE suppliers
(id NUMBER(5) PRIMARY KEY,
name VARCHAR2（20) NOT NULL
);

CREATE TABLE products
(id NUMBER(10) NOT NULL,
name VARCHAR2（20) NOT NULL,
suppliers_id number(10) NOT NULL,
CONSTRAINT fk_supplier FOREIGN KEY(suppliers_id) REFERENCES suppliers(id)
);
