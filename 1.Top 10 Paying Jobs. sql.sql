SELECT
    job_id,
    job_title,
    job_title_short,
    company_dim.name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
    left JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
where
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere'
order by
    salary_year_avg DESC
LIMIT 10;
