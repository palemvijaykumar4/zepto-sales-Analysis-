drop table if exists zepto;

create table zepto(
sku_id serial primary key,
category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountpercent numeric(5,2),
availablequantity integer,
discountedssellingprice numeric(8,2),
weightingrms integer,
outofstock boolean,
quantity integer
);



---- data exploration

---- count of rows

SELECT COUNT(*) FROM zepto;

copy zepto FROM 'C:\Program Files (x86)\postgresql\zepto_csv.csv' WITH (FORMAT CSV, HEADER);


copy zepto 
from 'C:\Program Files (x86)\postgresql\zepto_csv.csv'
delimiter ','
csv header;

----SAMPLE DATA
SELECT * FROM ZEPTO;


---- data exploration

---- count of rows

SELECT COUNT(*) FROM zepto;

copy zepto FROM 'C:\Program Files (x86)\postgresql\zepto_csv.csv' WITH (FORMAT CSV, HEADER);


copy zepto 
from 'C:\Program Files (x86)\postgresql\zepto_csv.csv'
delimiter ','
csv header;

--------------SAMPLE DATA-------------------------------------------------------------
SELECT * FROM ZEPTO;


select * from zepto 
where name is null
OR
category is null
or
MRP is null
or
discountpercent is null
or
availablequantity is null
or
discountedssellingprice is null
or
weightingrms is null
or
outofstock is null
or
quantity is null;

-------------different product categories------------------------------------------------

select distinct category from zepto order by category;

-------------products in stock and out of stock------------------------------------------

select outofstock, count(sku_id) from zepto group by outofstock;

-------------product names present multiple times-----------------------------------------

select name, count(sku_id) as "Number of SKUS"
from zepto group by name having count(sku_id) > 1
order by count(sku_id)desc;

-------------data cleaning ---------------------------------------------------------------

select * from zepto where mrp='0' or discountedssellingprice='0';

delete from zepto where mrp=0;
select *from zepto;

------------convert paise into rupee-------------------------------------------------------
update zepto set mrp=mrp/100.0, discountedssellingprice=discountedssellingprice/100.0;
select mrp,discountedssellingprice from zepto;
select * from zepto;

------------To find the top 10 best value product based on the discount percentage---------
select distinct name,mrp,discountpercent from zepto order by discountpercent desc limit 10;

------------what are the products with high mrp but out of stock---------------------------
select distinct name,mrp from zepto where outofstock=True and mrp>=200 order by mrp desc;

------------calculate Estimated Revenue for each category-----------------------------------
select category, sum(discountedssellingprice * availablequantity) as total_revenue from zepto
group by category order by total_revenue;

------------Find all products where MRP is greater than 500/- and discount is less than 10%
select distinct name,mrp,discountpercent from zepto where mrp>500 and discountpercent<10
order by mrp desc,discountpercent desc;

------------Identify the top 5 categories offering the highest average discount percentage---
select category, round(avg(discountpercent),2) as Avg_discount
from zepto group by category order by Avg_discount desc limit 5;

------------find price per gram for product above 100g and sort_by best value----------------
select distinct name, weightingrms, discountedssellingprice,round(discountedssellingprice/weightingrms,2)
as price_per_gram
from zepto where weightingrms >=100
order by price_per_gram limit 10;

select * from zepto;

-------------Group the product into categories like low, medium,Bulk--------------
select distinct name,weightingrms, 
case when weightingrms < 1000 then 'Low'
     when weightingrms < 5000 then 'Medium'
	 else 'Bulk'
	 end as weeight_category from zepto;

------------what is the total inventory weight per category---------------------
select category, sum(weightingrms * availablequantity) as total_weight from zepto
group by category order by total_weight;