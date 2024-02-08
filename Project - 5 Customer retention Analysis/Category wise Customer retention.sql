with category_MOM as (
select
	if(grouping(p.category), 'Grand Total', Category) as Category,
    count(distinct o1.customer_id) as Customers,
	coalesce(count(distinct case when extract(month from o2.order_date) = extract(month from o1.order_date) then o1.customer_id end), 0) as M1,
	coalesce(count(distinct case when extract(month from o2.order_date) = extract(month from o1.order_date) + 1 then o1.customer_id end), 0) as M2,
	coalesce(count(distinct case when extract(month from o2.order_date) = extract(month from o1.order_date) + 2 then o1.customer_id end), 0) as M3,
	coalesce(count(distinct case when extract(month from o2.order_date) = extract(month from o1.order_date) + 3 then o1.customer_id end), 0) as M4,
	coalesce(count(distinct case when extract(month from o2.order_date) = extract(month from o1.order_date) + 4 then o1.customer_id end), 0) as M5,
	coalesce(count(distinct case when extract(month from o2.order_date) = extract(month from o1.order_date) + 5 then o1.customer_id end), 0) as M6,
	coalesce(count(distinct case when extract(month from o2.order_date) = extract(month from o1.order_date) + 6 then o1.customer_id end), 0) as M7,
	coalesce(count(distinct case when extract(month from o2.order_date) = extract(month from o1.order_date) + 7 then o1.customer_id end), 0) as M8,
	coalesce(count(distinct case when extract(month from o2.order_date) = extract(month from o1.order_date) + 8 then o1.customer_id end), 0) as M9,
	coalesce(count(distinct case when extract(month from o2.order_date) = extract(month from o1.order_date) + 9 then o1.customer_id end), 0) as M10,
	coalesce(count(distinct case when extract(month from o2.order_date) = extract(month from o1.order_date) + 10 then o1.customer_id end), 0) as M11,
	coalesce(count(distinct case when extract(month from o2.order_date) = extract(month from o1.order_date) + 11 then o1.customer_id end), 0) as M12
from order_details o1
join order_details o2 on o1.customer_id = o2.customer_id
join producthierarchy p on p.product_id = o2.product_id
group by p.category with rollup)

-- select * from category_MOM;

select
	Category,
    Customers as '# of Unique Customers',
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
    from category_MOM; 