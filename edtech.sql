

create table edu (
			record_id int ,
            platform varchar(50),
            company_name varchar(100),
            edtech_segment varchar(120),
            content_type varchar(200),
            raw_text varchar(150),
            category varchar(100),
            issue_type varchar(100),
            sentiment varchar(80),
            date_posted date
            );
select * from edu;

-- Q1 - Fetch all records related to UpGrad
select * from edu
where company_name = 'UpGrad';

-- Q2 -Count total feedback records
select count(*) as total
from edu;

-- Q3 -List all distinct EdTech platforms
select distinct platform
from edu;

-- Q4- Find total complaints vs positive feedback
select category , count(*) as total
from edu
group by category;

-- Q5- Show records with Negative sentiment
select sentiment, count(*) as total 
from edu
where sentiment = 'Negative'
group by sentiment;

-- Q6 - Which company has the highest complaints?
select company_name , count(*) as highest_complain
from edu
where category = 'Complaint'
group by company_name
order by highest_complain desc;

-- Q7 - Platform-wise sentiment distribution
select platform , sentiment , count(*) as total
from edu
group by platform , sentiment
order by platform;

-- Q8- Top 3 issue types causing complaints

select issue_type , count(*) as top_3
from edu
where category = 'Complaint'
group by issue_type
order by top_3 desc limit 3;

-- Q9- Year-wise feedback trend
select extract(year from date_posted) as year,
			count(*) as total_feedback
            from edu
            group by year
            order by year;
            
-- Q10- Find companies with more than 50 complaints
select company_name ,count(*) as total
from edu 
where category = 'Complaint'
group by company_name
having count(*) > 10;

-- Q11-Most common issue type per company (Window Function)
with issue_avg as (
				select company_name , issue_type,
                count(*) as issue_count
                from edu 
                where category = 'Complaint'
                group by company_name, issue_type
                )
                select company_name , issue_type , issue_count
                from (
						select 
                        company_name,
                        issue_type,
                        issue_count,
                        row_number() over( partition by company_name
												order by issue_count desc
                                                ) as rn
                                                from issue_avg
                                                ) ranked
                                                where rn = 1
                                                
                        