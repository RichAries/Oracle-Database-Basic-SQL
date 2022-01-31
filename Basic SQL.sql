### Limits
SELECT occurred_at, accound_id, channel
FROM web_events
LIMIT 15;


### Orderby /*Always go with From commond*/
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


### WHERE
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


### Arithmetic Operator
SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;

SELECT id, account_id,
   poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per
FROM orders
LIMIT 10;


###Logical Operators: LIKE, IN, NOT, AND&BETWEEN, OR
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


### DISTINCT
SELECT distinct department_id  /*Distinct can remove repeate values*/
From employees


### DESC
DESC table /*To see the table details and data type*/
describe table


### String, Number, and Data Function
##SUBSTRING /*To organize varchar in a fit size*/
SELECT substr(job_title,1,15) FROM jobs
##TRUNC /*To round numerica values in a fit size，but it will not round up or down*/
SELECT trunc(999.98765,3) /* Result would be 999.987. Moreover, it can be used in numerical column*/
FROM dual

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

Format DATE values
SELECT first_name, TO_CHAR(hire_date, 'DD/MM/YYYY') /*MON in DD/MON/YYYY represents the month name */
FROM employees

FIlter DATE values
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
