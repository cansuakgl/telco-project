/* 
1.1 customers who are subcribed to 'Kobiye Destek' tariff
 select customer id, name and tariff name from the joint table of tariffs and customers, joined on the shared column tariff_id.
 In all of the rows that were selected, list the ones that have 'Kobiye Destek' as the tariff_name , ordered by customer id.
*/

SELECT
    c.customer_id,
    c.name,
    t.name
FROM customers c
JOIN tariffs t
    ON c.tariff_id = t.tariff_id
WHERE t.name = 'Kobiye Destek'
ORDER BY c.customer_id;

/* 
1.2 the most recently signed up customer subscribed to 'Kobiye Destek' tariff
 select customer id, name, city and signup date from the joint table of tariffs and customers, joined on the shared column tariff_id.
 from all the rows that have 'Kobiye Destek' as the tariff_name, list only the ones whose signup_date is equal to the latest signup_date among 'Kobiye Destek' customers, which is found through a subquery, ordered by customer id.
*/

SELECT
    c.customer_id,
    c.name,
    c.city,
    c.signup_date
FROM customers c
JOIN tariffs t
    ON c.tariff_id = t.tariff_id
WHERE t.name = 'Kobiye Destek'
AND c.signup_date = (
    SELECT MAX(c2.signup_date)
    FROM customers c2
    JOIN tariffs t2
        ON c2.tariff_id = t2.tariff_id
    WHERE t2.name = 'Kobiye Destek'
)
ORDER BY c.customer_id;

/* 
2.1 Find the distribution of tariffs among customers
join customer and tariff tables, group customers by tariff, show the amount of customers per tariff in descending order
*/

SELECT
    t.name,
    COUNT(c.customer_id) AS customer_count
FROM tariffs t
JOIN customers c
    ON t.tariff_id = c.tariff_id
GROUP BY t.name
ORDER BY customer_count DESC;

/* 
3.1 earliest customers to sign up
 select customer id, name and signup date from the customers table.
 list only the ones whose signup_date matches the earliest signup_date among all customers, found through a subquery, ordered by customer id
*/

SELECT
    customer_id,
    name,
    signup_date
FROM customers
WHERE signup_date = (
    SELECT MIN(signup_date)
    FROM customers
);

/* 
3.2 distribution of earliest customers across cities
 from the rows where signup_date matches the earliest signup_date (found through a subquery), group by city and show the total count for each
*/

SELECT
    city,
    COUNT(customer_id) AS customer_count
FROM customers
WHERE signup_date = (
    SELECT MIN(signup_date)
    FROM customers
)
GROUP BY city;

/* 
4.1 customers with missing monthly records
 list customer rows whose customer id does not appear in the monthly stats table
*/

SELECT
    customer_id
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM monthly_stats
);

/* 
4.2 distribution of missing customers across cities
 select city and count of customers from the customers table.
 from the rows where customer id does not appear in the monthly stats table, group by city and show the total count for each
*/

SELECT
    city,
    COUNT(customer_id) AS customer_count
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM monthly_stats
)
GROUP BY city;

/* 
5.1 customers who have used at least 75% of their data limit
 select customer id, name, data usage and data limit from the joint table of customers and tariffs, joined on the shared column tariff id, and joined with monthly stats on customer id.
 list only the ones where data_usage is at least 75% of data_limit
*/

SELECT
    c.customer_id,
    c.name,
    ms.data_usage,
    t.data_limit
FROM customers c
JOIN tariffs t
    ON c.tariff_id = t.tariff_id
JOIN monthly_stats ms
    ON c.customer_id = ms.customer_id
WHERE ms.data_usage >= t.data_limit * 0.75;

/* 
5.2 customers who have exhausted all of their package limits
 select customer id and name from the joint table of customers and tariffs, joined on the shared column tariff_id, and joined with monthly_stats on customer_id.
 list only the ones where data usage, minute usage and sms usage have all reached or exceeded their  limits
*/

SELECT
    c.customer_id,
    c.name
FROM customers c
JOIN tariffs t
    ON c.tariff_id = t.tariff_id
JOIN monthly_stats ms
    ON c.customer_id = ms.customer_id
WHERE ms.data_usage >= t.data_limit
AND ms.minute_usage >= t.minute_limit
AND ms.sms_usage >= t.sms_limit;

/* 
6.1 customers with unpaid fees
 select customer id, name and payment status from the joint table of customers and monthly_stats, joined on the shared column customer_id.
 list only the ones where payment_status is 'UNPAID', ordered by customer id
*/

SELECT
    c.customer_id,
    c.name,
    ms.payment_status
FROM customers c
JOIN monthly_stats ms
    ON c.customer_id = ms.customer_id
WHERE ms.payment_status = 'UNPAID'
ORDER BY c.customer_id;

/* 
6.2 distribution of payment statuses across tariffs
 select tariff name, payment status and count of customers from the joint table of tariffs, customers and monthly_stats, all joined on their shared columns.
 group by tariff name and payment status and show the total count for each combination, ordered by tariff name and payment status.
*/

SELECT
    t.name,
    ms.payment_status,
    COUNT(c.customer_id) AS customer_count
FROM tariffs t
JOIN customers c
    ON t.tariff_id = c.tariff_id
JOIN monthly_stats ms
    ON c.customer_id = ms.customer_id
GROUP BY t.name, ms.payment_status
ORDER BY t.name, ms.payment_status;







