drop database zepto; 
create database zepto;
use zepto;

--- data exploration

-- count of rows
select count(*)
from zepto;


-- null values
select * from zepto
where name is null
or name is null
or category is null
or mrp is null
or discountpercent is null
or availablequantity is null
or discountedsellingprice is null
or weightingms is null
or outofstock is null
or quantity is null;

-- different product categories

select distinct category
from zepto
order by category;

-- products in stock vs out of stock

select outofstock,count(*)
from zepto
group by outofstock;

-- product names present multiple times

select name,count(*)
from zepto
group by name
having count(*)>1
order by count(*) desc;

-- products with price 0
select * from zepto
where mrp=0 or discountedsellingprice=0;

set sql_safe_updates=0;

delete from zepto
where mrp=0;

-- convert paise into rupees
alter table zepto
modify mrp decimal(10,2),
modify discountedsellingprice decimal(10,2);

describe zepto;

select mrp,mrp/100,discountedsellingprice,discountedsellingprice/100
from zepto;

update zepto
set mrp=mrp/100,discountedsellingprice=discountedsellingprice/100;

select * from zepto;

-- top 10 best products based on discount

select distinct name,mrp,discountpercent
from zepto
order by discountpercent desc
limit 10;

-- product with high mrp but out of stock

select distinct name,mrp
from zepto
where outofstock='true' and mrp>300
order by mrp desc;

-- revenue for each category

select category,sum(discountedsellingprice*availablequantity) as revenue
from zepto
group by category
order by revenue desc;

-- products with mrp greater than 500 and discount lesser than 10%

select distinct name,mrp,discountedsellingprice
from zepto
where mrp>500 and discountpercent<10
order by mrp desc,discountedsellingprice desc;

-- top 5 products with highest avg discount percent

select distinct category,round(avg(discountpercent),2)as high_discount
from zepto
group by category
order by high_discount desc
limit 5;

-- price per gram products above 100 grams

select distinct name,discountedsellingprice,weightingms,round(discountedsellingprice/weightingms,2) as price_per_gram
from zepto
where weightingms>=100
order by price_per_gram;

-- group products into low,medium,bulk based on weight

select distinct name,weightingms,
case when weightingms<1000 then 'low'
when weightingms<5000 then 'medium'
else 'bulk'
end as weight_category
from zepto;

-- total inventory weight per categroy
 select distinct category,sum(weightingms*availablequantity) as weight_category
 from zepto
 group by category
 order by weight_category