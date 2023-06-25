# 3.06 Activity 1

-- Keep working on the `bank` database.

USE bank;

-- Use a CTE to display the first account opened by a district.

WITH cte_first_account AS (
	SELECT account_id, district_id, RANK () OVER (PARTITION BY district_id ORDER BY date) AS rank_date
    FROM bank.account
)
SELECT account_id, district_id FROM cte_first_account
WHERE rank_date= 1;

# 3.06 Activity 2

-- In order to spot possible fraud, we want to create a view **last_week_withdrawals** with total withdrawals by client in the last week.

CREATE OR REPLACE VIEW last_week_withdrawals AS 
WITH cte_max_date AS (
	SELECT *, (
		SELECT MAX(date) FROM bank.trans
    ) max_date FROM bank.trans
)
SELECT * FROM cte_max_date
WHERE date(date) >=  date_sub(max_date, interval 7 day);

SELECT * FROM last_week_withdrawals;

# 3.06 Activity 3

-- The table `client` has a field `birth_number` that encapsulates client birthday and sex. 
-- The number is in the form `YYMMDD` for men, and in the form `YYMM+50DD` for women, where `YYMMDD` is the date of birth. 
-- Create a view `client_demographics` with `client_id`, `birth_date` and `sex` fields. 
 -- Use that view and a CTE to find the number of loans by status and sex.

CREATE OR REPLACE VIEW client_demographics AS (
SELECT *, substr(birth_number, 1, 2) AS YY, substr(birth_number, 3, 2) AS Mn, substr(birth_number, 5, 2) AS DD,
 
 CASE WHEN convert(substr(birth_number, 3, 2), signed integer) > 13 THEN 'F' ELSE 'M' END AS sex,
 CASE WHEN convert(substr(birth_number, 3, 2), signed integer) > 13 THEN convert(substr(birth_number, 3, 2), signed integer) - 50 
 ELSE convert(substr(birth_number, 3, 2), signed integer) END AS MM
 
 FROM bank.client);

SELECT client_id, YY, MM, DD, SEX FROM client_demographics;