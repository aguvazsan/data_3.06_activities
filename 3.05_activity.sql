# 3.05 Activity 1

-- Keep working on the `bank` database.

USE bank;

-- Find out the average number of transactions by account. Get those accounts that have more transactions than the average.

SELECT account_id, count(trans_id) AS Trans_count
FROM bank.trans
GROUP BY account_id;

SELECT AVG(Trans_count) 
FROM (
    SELECT account_id, count(trans_id) AS Trans_count
    FROM bank.trans
    GROUP BY account_id
) subtrans;

SELECT account_id , COUNT(trans_id) AS Trans_bordador
FROM bank.trans
GROUP BY account_id
HAVING COUNT(trans_id) > (SELECT AVG(Trans_count) 
FROM (
    SELECT account_id, count(trans_id) AS Trans_count
    FROM bank.trans
    GROUP BY account_id
) subtrans);


# 3.05 Activity 2

-- 1. Get a list of accounts from Central Bohemia using a subquery.

SELECT * FROM bank.district;

SELECT * 
FROM bank.account
WHERE district_id IN (
    SELECT A1 
    FROM district 
    WHERE A3 = "Central Bohemia"
);

-- 2. Rewrite the previous as a join query.

SELECT a.* FROM bank.account a
JOIN bank.district d
ON a.district_id = d.a1
WHERE d.a3= "Central Bohemia";

-- 3. Discuss which method will be more efficient.

# 3.05 Activity 3

-- Find the most active customer for each district in Central Bohemia.




SELECT account_id , COUNT(trans_id) AS Trans_bordador
FROM bank.trans
WHERE account_id = (
	SELECT a.* FROM bank.account a
	JOIN bank.district d
	ON a.district_id = d.a1
	WHERE d.a3= "Central Bohemia");
    
SELECT a.account_id, COUNT(t.trans_id) AS num_transactions, d.a2 AS district_name,
DENSE_RANK() OVER (PARTITION BY a.district_id ORDER BY COUNT(t.trans_id) DESC) AS district_rank 
FROM bank.trans AS t
JOIN bank.account AS a ON t.account_id = a.account_id
JOIN bank.district AS d ON a.district_id = d.a1
WHERE d.a3 = 'Central Bohemia'
GROUP BY a.account_id, d.a2
ORDER BY num_transactions DESC;


SELECT * FROM bank.district;

SELECT *
FROM (
    SELECT a.account_id, a.district_id, COUNT(t.trans_id) AS total_transactions, d.a2 AS district,
    DENSE_RANK () OVER (
    PARTITION BY a.district_id 
    ORDER BY COUNT(t.trans_id) DESC
        ) district_rank
    FROM bank.account a
    JOIN bank.trans t ON a.account_id = t.account_id
    JOIN bank.district d ON a.district_id = d.a1
    WHERE district_id IN (
            SELECT A1 
            FROM bank.district  WHERE A3 = 'Central Bohemia')
    GROUP BY a.account_id, d.a2) t
WHERE district_rank = 1
ORDER BY total_transactions DESC;


-- Accounts with the highest amount transfered per district in 'Central Bohemia'.

SELECT * FROM (
    SELECT a.account_id, a.district_id, SUM(t.amount) AS total_amount,
    DENSE_RANK () OVER (
    PARTITION BY a.district_id 
    ORDER BY SUM(t.amount) DESC
        ) district_rank
    FROM bank.account a
    JOIN bank.trans t ON a.account_id = t.account_id
    WHERE district_id IN (
            SELECT A1 
            FROM bank.district  WHERE A3 = 'Central Bohemia')
    GROUP BY a.account_id) t
WHERE district_rank = 1
ORDER BY total_amount DESC;