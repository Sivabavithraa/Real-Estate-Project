##1.Retrieve details of top 10 properties for the town 'Berlin' and display them in ascending order based on the Sale Amount.
create index property_typ on data(`Property Type`);
CREATE INDEX town ON data(Town(255));
select `Property Type`, `Residential Type` ,`Assessed Value` as `Assessed Value in $`,`Sale Amount`as `Sale Amount in $`  ### used backticks since column name has space
from data
where town='Berlin'
order by `Sale Amount` desc
limit 10;

##2.Identify the top 10 towns where properties were sold in the same year as they were listed.

select `List Year`,Town,count(`Serial Number`) as count
from data 
where `List Year`= year(`Date Recorded`)
group by town,`List Year`
order by count desc
limit 10;

###3.Count the number of properties for each unique Residential Type

select `Residential Type`,count(`Serial Number`) as `Properties Count`
from data
group by `Residential Type`;

##4.Find the top 5 Property Type that has maximum Sales ratio in the year 2021

 select  `Property Type`,round(max(`Sales Ratio`),2) as `Max Sales Ratio`
 from data
 where year(`Date Recorded`)=2021
 group by  `Property Type`
 order by `Max Sales Ratio` desc
 limit 5;
 
 ##5.What are the top five least expensive commercial properties in Enfield compared to the average sale price across all towns?"
 
select Address,year(`Date Recorded`),`Property Type`,`Residential Type`,`Sale Amount` 
from data 
where Town="Enfield" and `Sale Amount` < (SELECT AVG(`Sale Amount`) from data)
and `Property Type`="Commercial"
order by `Sale Amount`
Limit 5;

##-6.Top5 Sale Amount for "Apartments" Property Type.

with cte as(
select Address,`Property Type`,`Sale Amount`as `sale amount in $`,
dense_rank() over(order by `Sale Amount`desc)as `Rank`
from data
where `Property Type`="Apartments")
select * from cte
where `Rank`< "6";


####7.Select top 10 town where properties sold at loss for the year 2021

with cte as(
select Town,Address,`Assessed Value`,`Sale Amount`,`Property Type`,`Residential Type`,`Date Recorded`,
(`Sale Amount`-`Assessed Value`) *-1 as Loss
from data)
select Town,Address,Loss
from cte
where Loss >0 and year(`Date Recorded`)=2021
order by Loss desc
limit 10;


##8.Calculate the year-over-year percentage change in the total Sale Amount for each town for the year 2021 vs 2020

with cte1 as(
select town,sum(`sale amount`) as totalsaleamount20
		from data
    where year(`Date Recorded`)=2020
    group by
        town),
 cte2 as(
		select town,sum(`sale amount`) as totalsaleamount21
		from data
    where year(`Date Recorded`)=2021
    group by
        town)
select a.town,a.totalsaleamount20,b.totalsaleamount21,
round((b.totalsaleamount21-a.totalsaleamount20)*100/a.totalsaleamount20,2) as `Growth%`
from cte1 as a
join cte2 b
on a.town=b.town
order by `Growth%` desc
limit 10;

 