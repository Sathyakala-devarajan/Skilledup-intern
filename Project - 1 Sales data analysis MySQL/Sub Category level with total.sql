select
	if(grouping(sub_category), 'Grand Total', sub_category) as 'Sub Category',
    sum(Yday_orders) as 'Yday Orders', concat(sum(Yday_order_growth), '%') as 'Yday Orders Growth',
    sum(Yday_gmv) as 'Yday GMV', concat(sum(Yday_gmv_growth), '%') as 'Yday GMV Growth',
    sum(Yday_revenue) as 'Yday Revenue', concat(sum(Yday_revenue_growth), '%') as 'Yday Revenue Growth',
    sum(Yday_unique_users) as 'Yday Unique Users', concat(sum(Yday_unique_users_growth), '%') as 'Yday Unique Users Growth',
    sum(Yday_new_users) as 'Yday New Users', concat(sum(Yday_new_user_growth), '%') as 'Yday New Users Growth',
    
    sum(MTD_orders) as 'MTD Orders', concat(sum(MTD_order_growth), '%') as 'MTD Orders Growth',
    sum(MTD_gmv) as 'MTD GMV', concat(sum(MTD_gmv_growth), '%') as 'MTD GMV Growth',
    sum(MTD_revenue) as 'MTD Revenue', concat(sum(MTD_revenue_growth), '%') as 'MTD Revenue Growth',
    sum(MTD_unique_users) as 'MTD Unique Users', concat(sum(MTD_unique_users_growth), '%') as 'MTD Unique Users Growth',
    sum(MTD_new_users) as 'MTD New Users', concat(sum(MTD_new_users_growth), '%') as 'MTD New Users Growth',
    
    sum(LMTD_orders) as 'LMTD Orders', #concat(sum(LMTD_order_growth), '%') as 'LMTD Orders Growth',
    sum(LMTD_gmv) as 'LMTD GMV', #concat(sum(LMTD_gmv_growth), '%') as 'LMTD GMV Growth',
    sum(LMTD_revenue) as 'LMTD Revenue', #concat(sum(LMTD_revenue_growth), '%') as 'LMTD Revenue Growth',
    sum(LMTD_unique_users) as 'LMTD Unique Users', #concat(sum(LMTD_unique_users), '%') as 'LMTD Unique Users Growth',
    sum(LMTD_new_users) as 'LMTD New Users', #concat(sum(LMTD_new_users), '%') as 'LMTD New Users Growth',
    
    sum(LM_orders) as 'LM Orders', #concat(sum(LM_order_growth), '%') as 'LM Orders Growth',
    sum(LM_gmv) as 'LM GMV', #concat(sum(LM_gmv_growth), '%') as 'LM GMV Growth',
    sum(LM_revenue) as 'LM Revenue', #concat(sum(LM_revenue_growth), '%') as 'LM Revenue Growth',
    sum(LM_unique_users) as 'LM Unique Users', #concat(sum(LM_unique_users), '%') as 'LM Unique Users Growth',
    sum(LM_new_users) as 'LM New Users'#, concat(sum(LM_new_users), '%') as 'LM New Users Growth'
    
    from
(
select
	sub_Category,
    Yday_orders, coalesce(round((Yday_orders - DaybeforeYday_orders) / nullif(DaybeforeYday_orders, 0) * 100, 0), 0) as Yday_order_growth,
    Yday_gmv, coalesce(round((Yday_gmv - DaybeforeYday_gmv) / nullif(DaybeforeYday_gmv, 0) * 100, 0), 0) Yday_gmv_growth,
    Yday_revenue, coalesce(round((Yday_revenue - DaybeforeYday_revenue) / nullif(DaybeforeYday_revenue, 0) * 100, 0), 0) as Yday_revenue_growth,
    Yday_unique_users, coalesce(round((Yday_unique_users - DaybeforeYday_unique_users) / nullif(DaybeforeYday_unique_users, 0) * 100, 0), 0) as Yday_unique_users_growth,
    Yday_new_users, coalesce(round((Yday_new_users - DaybeforeYday_new_users)/ nullif(DaybeforeYday_new_users, 0) * 100, 0), 0) as Yday_new_user_growth,
            
    MTD_orders, coalesce(round((MTD_orders - Prev_MTD_orders) / nullif(Prev_MTD_orders, 0) * 100, 0), 0) as MTD_order_growth,
    MTD_gmv, coalesce(round((MTD_gmv - Prev_MTD_gmv) / nullif(Prev_MTD_gmv, 0) * 100, 0), 0) as MTD_gmv_growth,     
    MTD_revenue, coalesce(round((MTD_revenue - Prev_MTD_revenue) / nullif(Prev_MTD_revenue, 0) * 100, 0), 0) as MTD_revenue_growth,   
    MTD_unique_users, coalesce(round((MTD_unique_users - Prev_MTD_unique_users)/ nullif(Prev_MTD_unique_users, 0) * 100, 0), 0) as MTD_unique_users_growth,
    MTD_new_users, coalesce(round((MTD_new_users - Prev_MTD_new_users) / nullif(Prev_MTD_new_users, 0) * 100, 0), 0) as MTD_new_users_growth,
	
    LMTD_orders, coalesce(round((LMTD_orders - prev_LMTD_orders) / nullif(prev_LMTD_orders, 0) * 100, 0), 0) as LMTD_order_growth,
    LMTD_gmv, coalesce(round((LMTD_gmv - prev_LMTD_gmv) / nullif(prev_LMTD_gmv, 0) * 100, 0), 0) as LMTD_gmv_growth,     
    LMTD_revenue, coalesce(round((LMTD_revenue - prev_LMTD_revenue) / nullif(prev_LMTD_revenue, 0) * 100, 0), 0) as LMTD_revenue_growth,   
    LMTD_unique_users, coalesce(round((LMTD_unique_users - prev_LMTD_unique_users) / nullif(prev_LMTD_unique_users, 0) * 100, 0), 0) as LMTD_unique_users_growth,
    LMTD_new_users, coalesce(round((LMTD_new_users - prev_LMTD_new_users) / nullif(prev_LMTD_new_users, 0) * 100, 0), 0) as LMTD_new_users_growth,
	
    LM_orders, #concat(coalesce(round((LM_orders - prev_LM_orders) / nullif(prev_LM_orders, 0) * 100, 0), 0), '%') as LM_order_growth,
    LM_gmv, #concat(coalesce(round((LM_gmv - prev_LM_gmv) / nullif(prev_LM_gmv, 0) * 100, 0), 0), '%') as LM_gmv_growth,     
    LM_revenue, #concat(coalesce(round((LM_revenue - prev_LM_revenue) / nullif(prev_LM_revenue, 0) * 100, 0), 0), '%') as LM_revenue_growth,   
    LM_unique_users, #concat(coalesce(round((LM_unique_users - prev_LM_unique_users) / nullif(prev_LM_unique_users, 0) * 100, 0), 0), '%') as LM_unique_users_growth,
    LM_new_users #concat(coalesce(round((LM_new_users - prev_LM_new_users) / nullif(prev_LM_new_users, 0) * 100, 0), 0), '%') as LM_new_users_growth
    
    from (
        select 
        sub_category,
	#Yday details and Daybefore details
        coalesce(sum(case when order_date = (curdate() - interval 1 day) then orders end), 0) as Yday_orders,
        coalesce(sum(case when order_date = (curdate() - interval 2 day) then orders end), 0) as DaybeforeYday_orders,
		coalesce(sum(case when order_date = (curdate() - interval 1 day) then gmv end), 0) as Yday_gmv,
		coalesce(sum(case when order_date = (curdate() - interval 2 day) then gmv end), 0) as DaybeforeYday_gmv,
		coalesce(sum(case when order_date = (curdate() - interval 1 day) then revenue end), 0) as Yday_revenue,
		coalesce(sum(case when order_date = (curdate() - interval 2 day) then revenue end), 0) as DaybeforeYday_revenue,
		coalesce(sum(case when order_date = (curdate() - interval 1 day) then customers end), 0) as Yday_unique_users,
		coalesce(sum(case when order_date = (curdate() - interval 2 day) then customers end), 0) as DaybeforeYday_unique_users,
		coalesce(sum(case when order_date = (curdate() - interval 1 day) and user_rank = 1 then 1 end), 0) as Yday_new_users,
		coalesce(sum(case when order_date = (curdate() - interval 2 day) and user_rank = 1 then 1 end), 0) as DaybeforeYday_new_users,
		
	# MTD details (Starting of current month to today) and Previous MTD details (Starting of previous month to current date of previous month)
		coalesce(sum(case when order_date between date_format(curdate(), "%y-%m-01") and curdate() then orders end), 0) as MTD_orders,
		coalesce(sum(case when order_date between date_add(date_format(curdate(), "%y-%m-01"), interval -1 month) and (curdate() - interval 1 month) then orders end), 0) as Prev_MTD_orders,
		coalesce(sum(case when order_date between date_format(curdate(), "%y-%m-01") and curdate() then gmv end), 0) as MTD_gmv,
		coalesce(sum(case when order_date between date_add(date_format(curdate(), "%y-%m-01"), interval -1 month) and (curdate() - interval 1 month) then gmv end), 0) as Prev_MTD_gmv,
		coalesce(sum(case when order_date between date_format(curdate(), "%y-%m-01") and curdate() then revenue end), 0) as MTD_revenue,
		coalesce(sum(case when order_date between date_add(date_format(curdate(), "%y-%m-01"), interval -1 month) and (curdate() - interval 1 month) then revenue end), 0) as Prev_MTD_revenue,
		coalesce(sum(case when order_date between date_format(curdate(), "%y-%m-01") and curdate() then customers end), 0) as MTD_unique_users,
		coalesce(sum(case when order_date between date_add(date_format(curdate(), "%y-%m-01"), interval -1 month) and (curdate() - interval 1 month) then customers end), 0) as Prev_MTD_unique_users,
        coalesce(sum(case when order_date between date_format(curdate(), "%y-%m-01") and curdate() and user_rank = 1 then 1 end), 0) as MTD_new_users,
		coalesce(sum(case when order_date between date_add(date_format(curdate(), "%y-%m-01"), interval -1 month) and (curdate() - interval 1 month) and user_rank = 1 then 1 end), 0) as Prev_MTD_new_users,
    
    # LMTD details (Starting of previous month to today date) and Previous LMTD details (Starting of Month before month to current date of previous month)
		coalesce(sum(case when order_date between date_format(curdate() - interval 1 month, '%y-%m-01') and curdate() then orders end), 0) as LMTD_orders,
		coalesce(sum(case when order_date between (date_format(curdate(),'%y-%m-01') - interval 2 month) and (curdate() - interval 1 month) then orders end), 0) as Prev_LMTD_orders,
		coalesce(sum(case when order_date between date_format(curdate() - interval 1 month, '%y-%m-01') and curdate() then gmv end), 0) as LMTD_gmv,
		coalesce(sum(case when order_date between (date_format(curdate(),'%y-%m-01') - interval 2 month) and (curdate() - interval 1 month) then gmv end), 0) as Prev_LMTD_gmv,
		coalesce(sum(case when order_date between date_format(curdate() - interval 1 month, '%y-%m-01') and curdate() then revenue end), 0) as LMTD_revenue,
		coalesce(sum(case when order_date between (date_format(curdate(),'%y-%m-01') - interval 2 month) and (curdate() - interval 1 month) then revenue end), 0) as Prev_LMTD_revenue,
		coalesce(sum(case when order_date between date_format(curdate() - interval 1 month, '%y-%m-01') and curdate() then customers end), 0) as LMTD_unique_users,
		coalesce(sum(case when order_date between (date_format(curdate(),'%y-%m-01') - interval 2 month) and (curdate() - interval 1 month) then customers end), 0) as Prev_LMTD_unique_users,
		coalesce(sum(case when order_date between date_format(curdate() - interval 1 month, '%y-%m-01') and curdate() and user_rank = 1 then 1 end), 0) as LMTD_new_users,
		coalesce(sum(case when order_date between (date_format(curdate(),'%y-%m-01') - interval 2 month) and (curdate() - interval 1 month) and user_rank = 1  then 1 end), 0) as Prev_LMTD_new_users,
		
	# LM details (Starting of previous month to end of previous month) and Previous LM details (Starting of Month before month to end of month before month)
		coalesce(sum(case when order_Date >= date_format(curdate() - interval 1 month, '%y-%m-01') and order_date < date_format(curdate(), '%y-%m-01') then orders end), 0) as LM_orders,
		coalesce(sum(case when order_Date >= date_format(curdate() - interval 2 month, '%y-%m-01') and order_date < date_format(curdate() - interval 1 month, '%y-%m-01') then orders end), 0) as Prev_LM_orders,
        coalesce(sum(case when order_Date >= date_format(curdate() - interval 1 month, '%y-%m-01') and order_date < date_format(curdate(), '%y-%m-01') then gmv end), 0) as LM_gmv,
		coalesce(sum(case when order_Date >= date_format(curdate() - interval 2 month, '%y-%m-01') and order_date < date_format(curdate() - interval 1 month, '%y-%m-01') then gmv end), 0) as Prev_LM_gmv,
        coalesce(sum(case when order_Date >= date_format(curdate() - interval 1 month, '%y-%m-01') and order_date < date_format(curdate(), '%y-%m-01') then revenue end), 0) as LM_revenue,
		coalesce(sum(case when order_Date >= date_format(curdate() - interval 2 month, '%y-%m-01') and order_date < date_format(curdate() - interval 1 month, '%y-%m-01') then revenue end), 0) as Prev_LM_revenue,
        coalesce(sum(case when order_Date >= date_format(curdate() - interval 1 month, '%y-%m-01') and order_date < date_format(curdate(), '%y-%m-01') then customers end), 0) as LM_unique_users,
		coalesce(sum(case when order_Date >= date_format(curdate() - interval 2 month, '%y-%m-01') and order_date < date_format(curdate() - interval 1 month, '%y-%m-01') then customers end), 0) as Prev_LM_unique_users,
        coalesce(sum(case when order_Date >= date_format(curdate() - interval 1 month, '%y-%m-01') and order_date < date_format(curdate(), '%y-%m-01') and user_rank = 1 then 1 end), 0) as LM_new_users,
		coalesce(sum(case when order_Date >= date_format(curdate() - interval 2 month, '%y-%m-01') and order_date < date_format(curdate() - interval 1 month, '%y-%m-01') and user_rank = 1 then 1 end), 0) as Prev_LM_new_users
        from (
			select 
			p.sub_category,
			o.order_date,
			count(distinct order_id) as orders,
			sum(selling_price) as gmv,
			count(distinct customer_id) as customers,
			round(sum(selling_price) / 1.18, 0) as revenue,
			rank() over (partition by o.customer_id order by o.order_date) as user_rank
			from order_details o
			left join producthierarchy p on o.product_id = p.product_id
			where o.order_date >= date_add(curdate(), interval -1  year)
			group by p.sub_category, o.order_date, o.customer_id
			) x
	group by sub_category
   ) y
group by sub_category
) z
group by sub_category with rollup