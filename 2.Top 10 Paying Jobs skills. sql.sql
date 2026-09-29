WITH top_10_jobs AS 
(
SELECT
    job_id,
    job_title,
    company_dim.name AS company_name,
    salary_year_avg
FROM
    job_postings_fact
    left JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
where
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere'
order by
    salary_year_avg DESC
LIMIT 10
)
select 
    top_10_jobs.*,
    skills_dim.skills
from top_10_jobs
inner JOIN skills_job_dim ON top_10_jobs.job_id = skills_job_dim.job_id
inner JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
 order by
    top_10_jobs.salary_year_avg DESC