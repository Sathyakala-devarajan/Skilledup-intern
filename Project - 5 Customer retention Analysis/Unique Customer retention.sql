WITH cohorts AS (
  SELECT
    customer_id,
    DATE_FORMAT(MIN(order_date), '%Y-%m-01') AS first_order_month 
  FROM order_details
  GROUP BY customer_id
),

months_retained AS (
  SELECT 
    c.customer_id, c.first_order_month,
    monthname(c.first_order_month) as Month,
    DATE_FORMAT(o.order_date, '%Y-%m-01') AS order_month, 
    ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS month_num
  FROM cohorts c
  JOIN order_details o ON o.customer_id = c.customer_id
               AND o.order_date > c.first_order_month
),

-- select * from months_retained;
pivoted AS (
    SELECT
		monthname(first_order_month) AS cohort_month,
		extract(month from first_order_month) as cohort_num,
		count(distinct customer_id) as Customers,
		coalesce(SUM(IF(month_num = 1, 1, 0)), 0) AS m1,
		coalesce(SUM(IF(month_num = 2, 1, 0)), 0) AS m2,
		coalesce(SUM(IF(month_num = 3, 1, 0)), 0) AS m3,
		coalesce(SUM(IF(month_num = 4, 1, 0)), 0) AS m4,  
		coalesce(SUM(IF(month_num = 5, 1, 0)), 0) AS m5,
		coalesce(SUM(IF(month_num = 6, 1, 0)), 0) AS m6,
		coalesce(SUM(IF(month_num = 7, 1, 0)), 0) AS m7,
		coalesce(SUM(IF(month_num = 8, 1, 0)), 0) AS m8,
		coalesce(SUM(IF(month_num = 9, 1, 0)), 0) AS m9,  
		coalesce(SUM(IF(month_num = 10, 1, 0)), 0) AS m10,
		coalesce(SUM(IF(month_num = 11, 1, 0)), 0) AS m11,
		coalesce(SUM(IF(month_num = 12, 1, 0)), 0) AS m12
	FROM months_retained
	GROUP BY cohort_month, cohort_num
	order by cohort_num
  )

SELECT 
	cohort_month as 'Month',
    Customers as '# of Unique Customers',
	M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12,
    concat(round(100 * m1 / Customers, 0), '%') as 'M1 (%)',
    concat(round(100 * m2 / Customers, 0), '%') as 'M2 (%)',
    concat(round(100 * m3 / Customers, 0), '%') as 'M3 (%)',
    concat(round(100 * m4 / Customers, 0), '%') as 'M4 (%)',
    concat(round(100 * m5 / Customers, 0), '%') as 'M5 (%)',
    concat(round(100 * m6 / Customers, 0), '%') as 'M6 (%)',
    concat(round(100 * m7 / Customers, 0), '%') as 'M7 (%)',
    concat(round(100 * m8 / Customers, 0), '%') as 'M8 (%)',
    concat(round(100 * m9 / Customers, 0), '%') as 'M9 (%)',
    concat(round(100 * m10 / Customers, 0), '%') as 'M10 (%)',
    concat(round(100 * m11 / Customers, 0), '%') as 'M11 (%)',
    concat(round(100 * m12 / Customers, 0), '%') as 'M12 (%)'
FROM pivoted
ORDER BY cohort_num;