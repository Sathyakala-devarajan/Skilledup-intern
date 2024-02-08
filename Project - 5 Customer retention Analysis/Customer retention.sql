select * from order_details;

-- order_month table
with t1 as (
	select *, date_format(order_date, '%Y-%m-01') order_month
    from order_details
)

-- Cohort_month table
-- select * from t1
, t2 as (
	select customer_id, date_format (min(order_date), '%Y-%m-01') as cohort_month
    from t1
    group by customer_id
    -- having count(order_id) = 1
)

-- cohort_index table
-- select * from t2
, t3 as (
	select t1.customer_id, t1.order_date, t1.order_month, t2.cohort_month,
    -- datediff(month, cast(t2.cohort_month as date), cast(t1.order_month as date)) + 1 as cohort_index1,
    (month(cohort_month) - month(order_month)) + 1 AS cohort_index,
    count(distinct t1.customer_id) as customers
    from t1
    join t2
    on t1.customer_id = t2.customer_id and t1.order_date > t1.order_month
    group by t1.customer_id, t1.order_date, t1.order_month, t2.cohort_month
)

-- select * from t3;
, t4 as (
select
	monthname(cohort_month) as Month,
    	month(cohort_month) as month_num, count(distinct customer_id) customers,
		coalesce(Count(DISTINCT CASE WHEN EXTRACT(MONTH FROM order_month) = EXTRACT(MONTH FROM cohort_month) THEN customer_id END), 0) AS M1,
		coalesce(Count(DISTINCT CASE WHEN EXTRACT(MONTH FROM order_month) = EXTRACT(MONTH FROM cohort_month) + 1 THEN customer_id END), 0) AS M2,
		coalesce(Count(DISTINCT CASE WHEN EXTRACT(MONTH FROM order_month) = EXTRACT(MONTH FROM cohort_month) + 2 THEN customer_id END), 0) AS M3,
		coalesce(Count(DISTINCT CASE WHEN EXTRACT(MONTH FROM order_month) = EXTRACT(MONTH FROM cohort_month) + 3 THEN customer_id END), 0) AS M4,
		coalesce(Count(DISTINCT CASE WHEN EXTRACT(MONTH FROM order_month) = EXTRACT(MONTH FROM cohort_month) + 4 THEN customer_id END), 0) AS M5,
		coalesce(Count(DISTINCT CASE WHEN EXTRACT(MONTH FROM order_month) = EXTRACT(MONTH FROM cohort_month) + 5 THEN customer_id END), 0) AS M6,
		coalesce(Count(DISTINCT CASE WHEN EXTRACT(MONTH FROM order_month) = EXTRACT(MONTH FROM cohort_month) + 6 THEN customer_id END), 0) AS M7,
		coalesce(Count(DISTINCT CASE WHEN EXTRACT(MONTH FROM order_month) = EXTRACT(MONTH FROM cohort_month) + 7 THEN customer_id END), 0) AS M8,
		coalesce(Count(DISTINCT CASE WHEN EXTRACT(MONTH FROM order_month) = EXTRACT(MONTH FROM cohort_month) + 8 THEN customer_id END), 0) AS M9,
		coalesce(Count(DISTINCT CASE WHEN EXTRACT(MONTH FROM order_month) = EXTRACT(MONTH FROM cohort_month) + 9 THEN customer_id END), 0) AS M10,
		coalesce(Count(DISTINCT CASE WHEN EXTRACT(MONTH FROM order_month) = EXTRACT(MONTH FROM cohort_month) + 10 THEN customer_id END), 0) AS M11,
		coalesce(Count(DISTINCT CASE WHEN EXTRACT(MONTH FROM order_month) = EXTRACT(MONTH FROM cohort_month) + 11 THEN customer_id END), 0) AS M12
	from t3
group by Month, month_num
order by month_num
)

, customer_retention as (
select Month, Customers as '# of Unique Customers', M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12
from t4
)

-- select * from customer_retention;

select Month, Customers as '# of Unique Customers', 
	concat(round(100 * m1 / Customers, 0), '%') as 'M1',
    concat(round(100 * m2 / Customers, 0), '%') as 'M2',
    concat(round(100 * m3 / Customers, 0), '%') as 'M3',
    concat(round(100 * m4 / Customers, 0), '%') as 'M4',
    concat(round(100 * m5 / Customers, 0), '%') as 'M5',
    concat(round(100 * m6 / Customers, 0), '%') as 'M6',
    concat(round(100 * m7 / Customers, 0), '%') as 'M7',
    concat(round(100 * m8 / Customers, 0), '%') as 'M8',
    concat(round(100 * m9 / Customers, 0), '%') as 'M9',
    concat(round(100 * m10 / Customers, 0), '%') as 'M10',
    concat(round(100 * m11 / Customers, 0), '%') as 'M11',
    concat(round(100 * m12 / Customers, 0), '%') as 'M12'
    from t4;
    