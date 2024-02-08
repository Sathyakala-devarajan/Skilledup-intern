# Order range for category
select
    if(grouping(order_range), 'Grand Total', order_range) as 'Order range',
    coalesce(sum(case when order_date = (curdate() - interval 1 day) then customers end), 0) as 'Yday Users',
    coalesce(sum(case when order_date between date_format(curdate(), "%y-%m-01") and curdate() then customers end), 0) as 'MTD Users',
    coalesce(sum(case when order_date between date_format(curdate() - interval 1 month, '%y-%m-01') and curdate() then customers end), 0) as 'LMTD Users',
	coalesce(sum(case when order_date >= date_format(curdate() - interval 1 month, '%y-%m-01') and order_date < date_format(curdate(), '%y-%m-01') then customers end), 0) as 'LM Users'
    from (
		select 
			case 
				when count(distinct order_id) between 1 and 2 then '1-2'
				when count(distinct order_id) between 3 and 5 then '3-5'
				when count(distinct order_id) between 6 and 10 then '6-10'
				else 'Gtr10'
			end as order_range,
			p.category,
			o.order_date,
			count(distinct order_id) as orders,
			sum(selling_price) as gmv,
			round(sum(selling_price) / 1.18, 0) as revenue,
            count(distinct o.customer_id) as customers,
			count(distinct r.customer_id) as new_user
			from order_details o
			left join producthierarchy p on o.product_id = p.product_id
            left join (
				select o1.customer_id, 
                rank() over (partition by o1.customer_id order by o1.order_date) as user_rank
				from order_details as o1
                join producthierarchy p1 on o1.product_id = p1.product_id
                ) as r 
			on o.customer_id = r.customer_id
			where order_date >= date_add(curdate(), interval -1 year) and user_rank = 1
			group by category, order_date
		) x
group by order_range with rollup;

# Order range for sub_category
select
    if(grouping(order_range), 'Grand Total', order_range) as 'Order Range',
    coalesce(sum(case when order_date = (curdate() - interval 1 day) then customers end), 0) as 'Yday Users',
    coalesce(sum(case when order_date between date_format(curdate(), "%y-%m-01") and curdate() then customers end), 0) as 'MTD Users',
    coalesce(sum(case when order_date between date_format(curdate() - interval 1 month, '%y-%m-01') and curdate() then customers end), 0) as 'LMTD Users',
	coalesce(sum(case when order_date >= date_format(curdate() - interval 1 month, '%y-%m-01') and order_date < date_format(curdate(), '%y-%m-01') then customers end), 0) as 'LM Users'
    from (
		select 
			case 
				when count(distinct order_id) between 1 and 2 then '1-2'
				when count(distinct order_id) between 3 and 5 then '3-5'
				when count(distinct order_id) between 6 and 10 then '6-10'
				else 'Gtr10'
			end as order_range,
			p.sub_category,
			o.order_date,
			count(distinct order_id) as orders,
			sum(selling_price) as gmv,
			round(sum(selling_price) / 1.18, 0) as revenue,
            count(distinct o.customer_id) as customers,
			count(distinct r.customer_id) as new_user
			from order_details o
			left join producthierarchy p on o.product_id = p.product_id
            left join (
				select o1.customer_id, 
                rank() over (partition by o1.customer_id order by o1.order_date) as user_rank
				from order_details as o1
                join producthierarchy p1 on o1.product_id = p1.product_id
                ) as r 
			on o.customer_id = r.customer_id
			where order_date >= date_add(curdate(), interval -1 year) and user_rank = 1
			group by sub_category, order_date
		) x
group by order_range with rollup;

# GMV range for category
select
    if(grouping(GMV_range), 'Grand Total', GMV_range) as 'GMV Range',
    coalesce(sum(case when order_date = (curdate() - interval 1 day) then customers end), 0) as 'Yday Users',
    coalesce(sum(case when order_date between date_format(curdate(), "%y-%m-01") and curdate() then customers end), 0) as 'MTD Users',
    coalesce(sum(case when order_date between date_format(curdate() - interval 1 month, '%y-%m-01') and curdate() then customers end), 0) as 'LMTD Users',
	coalesce(sum(case when order_date >= date_format(curdate() - interval 1 month, '%y-%m-01') and order_date < date_format(curdate(), '%y-%m-01') then customers end), 0) as 'LM Users'
    from (
		select 
			case 
				when sum(selling_price) between 1 and 100 then '1-100'
				when sum(selling_price) between 101 and 500 then '101-500'
				when sum(selling_price) between 501 and 1000 then '501-1000'
				when sum(selling_price) between 1001 and 10000 then '1001-10000'
				when sum(selling_price) between 10001 and 100000 then '10001-100000'
				else 'Gtr 1L'
			end as GMV_range,
			p.category,
			o.order_date,
			count(distinct order_id) as orders,
			sum(selling_price) as gmv,
			round(sum(selling_price) / 1.18, 0) as revenue,
            count(distinct o.customer_id) as customers,
			count(distinct r.customer_id) as new_user
			from order_details o
			left join producthierarchy p on o.product_id = p.product_id
            left join (
				select o1.customer_id, 
                rank() over (partition by o1.customer_id order by o1.order_date) as user_rank
				from order_details as o1
                join producthierarchy p1 on o1.product_id = p1.product_id
                ) as r 
			on o.customer_id = r.customer_id
			where user_rank = 1
			group by category, order_date
		) x
group by GMV_range with rollup
order by case 
            when GMV_range = '1-100' then 1
            when GMV_range = '101-500' then 2
            when GMV_range = '501-1000' then 3
            when GMV_range = '1001-10000' then 4
            when GMV_range = '10001-100000' then 5
		 else 6
	end;

# GMV range for sub_category
select
    if(grouping(GMV_range), 'Grand Total', GMV_range) as 'GMV Range',
    coalesce(sum(case when order_date = (curdate() - interval 1 day) then customers end), 0) as 'Yday Users',
    coalesce(sum(case when order_date between date_format(curdate(), "%y-%m-01") and curdate() then customers end), 0) as 'MTD Users',
    coalesce(sum(case when order_date between date_format(curdate() - interval 1 month, '%y-%m-01') and curdate() then customers end), 0) as 'LMTD Users',
	coalesce(sum(case when order_date >= date_format(curdate() - interval 1 month, '%y-%m-01') and order_date < date_format(curdate(), '%y-%m-01') then customers end), 0) as 'LM Users'
    from (
		select 
			case 
				when sum(selling_price) between 1 and 100 then '1-100'
				when sum(selling_price) between 101 and 500 then '101-500'
				when sum(selling_price) between 501 and 1000 then '501-1000'
				when sum(selling_price) between 1001 and 10000 then '1001-10000'
				when sum(selling_price) between 10001 and 100000 then '10001-100000'
				else 'Gtr 1L'
			end as GMV_range,
			p.sub_category,
			o.order_date,
			count(distinct order_id) as orders,
			sum(selling_price) as gmv,
			round(sum(selling_price) / 1.18, 0) as revenue,
            count(distinct o.customer_id) as customers,
			count(distinct r.customer_id) as new_user
			from order_details o
			left join producthierarchy p on o.product_id = p.product_id
            left join (
				select o1.customer_id, 
                rank() over (partition by o1.customer_id order by o1.order_date) as user_rank
				from order_details as o1
                join producthierarchy p1 on o1.product_id = p1.product_id
                ) as r 
			on o.customer_id = r.customer_id
			where user_rank = 1
			group by sub_category, order_date
		) x
group by GMV_range with rollup
order by case 
            when GMV_range = '1-100' then 1
            when GMV_range = '101-500' then 2
            when GMV_range = '501-1000' then 3
            when GMV_range = '1001-10000' then 4
            when GMV_range = '10001-100000' then 5
		 else 6
	end; 
