-- Cardekho Used Car Market Analysis Using SQL GitHub SQL Case Study - 35 Business Questions
# Section 1 – Data Exploration

-- Q1. How many total cars are available?
select 
count(*) as total_cars
from cardekho_dataset;

-- Q2. How many unique brands are there?
select 
count(distinct brand) as unique_brands 
from cardekho_dataset;

-- Q3. How many unique models are there?
select 
count(distinct model) as unique_models 
from cardekho_dataset;

-- Q4. What is the price range of cars?
select 
max(selling_price) as maximum_price,
min(selling_price) as minimum_price
from cardekho_dataset;

-- Q5. What are the top 10 brands by number of listings?
select brand,
count(brand) as total_listings
from cardekho_dataset 
group by brand 
order by total_listings desc
limit 10;

-- Q6. What is the average selling price of all cars?
select 
round(avg(selling_price),2) as avg_selling_price
from cardekho_dataset;

-- Q7. Which brand has the highest average selling price?
select brand, 
round(avg(selling_price),2) as avg_selling_price 
from cardekho_dataset
group by brand
order by avg_selling_price desc
limit 1;

-- Q8. Which model has the highest average selling price?
select model, 
round(avg(selling_price),2) as avg_selling_price 
from cardekho_dataset
group by model
order by avg_selling_price desc
limit 1;

-- Q9. What are the top 10 most expensive cars?
select car_name, brand, selling_price
from cardekho_dataset
order by selling_price desc
limit 10;

-- Q10. Which brands have an average selling price above the overall average?
select brand, 
avg(selling_price) as avg_selling_price
from cardekho_dataset
group by brand
having avg(selling_price) > (
select avg(selling_price) 
from cardekho_dataset);

-- Q11. Which fuel type has the highest average selling price?
select fuel_type,
round(avg(selling_price),2) as avg_selling_price
from cardekho_dataset
group by fuel_type
order by avg_selling_price desc
limit 1;

-- Q12. Which transmission type has the highest average selling price?
select transmission_type, 
round(avg(selling_price),2) as avg_selling_price
from cardekho_dataset
group by transmission_type 
order by avg_selling_price desc
limit 1;

-- Q13. Which seller type lists the most expensive cars?
select seller_type,
max(selling_price) as maximum_selling_price
from cardekho_dataset
group by seller_type
order by maximum_selling_price desc
limit 1;

-- Q14. How does vehicle age affect selling price?
select vehicle_age,
avg(selling_price) as avg_selling_price
from cardekho_dataset
group by vehicle_age
order by vehicle_age asc;

-- Q15. Which vehicle age has the highest average selling price?
select vehicle_age, 
avg(selling_price) as avg_selling_price
from cardekho_dataset
group by vehicle_age 
order by avg_selling_price desc
limit 1;

-- Q16. Does higher km_driven reduce selling price?
select
case 
when km_driven < 30000 then '0-30km'
when km_driven < 60000 then '30-60km'
when km_driven < 100000 then '60-100km'
else '100+km'
end as km_category,
count(*) as total_cars,
round(avg(selling_price),2) as avg_selling_price
from cardekho_dataset 
group by km_category
order by avg_selling_price desc; 

-- Q17. Which cars have the lowest mileage?
select brand, model, mileage
from cardekho_dataset
order by mileage asc
limit 10;

-- Q18: Which cars have the highest engine capacity?
select car_name, brand, model,engine 
from cardekho_dataset
order by engine desc
limit 5;

-- Q19. Which cars have the highest max power?
select car_name,brand,model,max_power
from cardekho_dataset
order by max_power desc
limit 5;

-- Q20. Does engine size influence selling price?
select
case 
when engine < 1000 then '<1000 CC'
when engine < 1500 then '1000–1499 CC'
when engine < 2000 then '1500–1999 CC'
else '2000 CC and above'
end as engine_category,
count(*) as total_cars,
round(avg(selling_price),2) as avg_selling_price
from cardekho_dataset
group by engine_category
order by avg_selling_price desc;

-- Q21. Rank brands by average selling price.?
select brand,avg_selling_price,
rank() over (order by avg_selling_price desc) as rnk 
from (select brand,round(avg(selling_price),2) as avg_selling_price
from cardekho_dataset
group by brand) as brand_rank;

-- Q22. Find the top 3 most expensive cars in each brand.
select * 
from (select *,
dense_rank() over(partition by brand order by selling_price desc) as rnk
from cardekho_dataset) as ranked_brand
where rnk <= 3;

-- Q23. Find the most expensive car for each fuel type.
select * 
from (select *,
dense_rank() over(partition by fuel_type order by selling_price desc) as rnk 
from cardekho_dataset) as  ranked_cars
where rnk = 1;

-- Q24. Create Budget, Mid-range, and Premium price categories using CASE WHEN.
select *,
case 
when selling_price <=500000 then 'Budget'
when selling_price  <= 1500000 then 'Mid Range'
else 'Premium'
end as price_segment
from cardekho_dataset;

-- Q25. Find brands with more than 50 listings.
select brand,count(*) as total_cars
from cardekho_dataset
group by brand 
having count(*) > 50
order by total_cars desc;

-- Q26. Calculate each brand's market share
select brand,count(*) as total_cars,
round(count(*)*100.0/(select count(*) from cardekho_dataset ),2) as market_share_percentage
from cardekho_dataset
group by brand
order by market_share_percentage desc ;

-- Q27. Find the best value cars (high power with relatively low price).
select brand, model,selling_price,max_power,
max_power/nullif(selling_price,0) as value_score
from cardekho_dataset 
order by value_score desc,
selling_price ASC;

-- Q28. Find brands whose average selling price is above the company average.
select brand,
avg(selling_price) as avg_selling_price
from cardekho_dataset
group by brand
having avg(selling_price) >(
select avg(selling_price)
from cardekho_dataset);

-- Q29. Rank cars using DENSE_RANK().
select *,
dense_rank() over (order by selling_price desc) as rnk
from cardekho_dataset;

-- Q30. Calculate running average selling price by brand.
select *,
avg(selling_price) over(
partition by brand 
order by selling_price desc 
ROWS BETWEEN UNBOUNDED PRECEDING
AND CURRENT ROW)
 as running_avg_selling_price
from cardekho_dataset;

-- Q31. Find the second most expensive car in each brand
select *
from (
select *,
dense_rank() over(
partition by brand 
order by selling_price desc
) as rnk 
from cardekho_dataset
) as ranked_brand
where rnk = 2;

-- Q32. Find brands where the average price is greater than ₹10 lakh
select brand,round(avg(selling_price),2) as avg_price
from cardekho_dataset
group by brand 
having avg(selling_price) > 1000000;

-- Q33. Compare automatic vs manual price difference.
select transmission_type,round(avg(selling_price),2) as avg_selling_price
from cardekho_dataset
group by transmission_type
order by avg_selling_price desc;

-- Q34. Find the top 5 brands contributing the highest total sales value.
select brand,sum(selling_price) as total_sales_value
from cardekho_dataset
group by brand 
order by total_sales_value desc 
limit 5;

-- Q35. Write five final business recommendations based on the analysis
# 1. Focus on High-Revenue Brands
# 2. Increase Availability of High-Demand Fuel Types
# 3. Promote Automatic Cars in Premium Segments
# 4. Improve Pricing Strategy Using Market Analysis
# 5. Optimize Inventory Based on Brand and Model Performance
