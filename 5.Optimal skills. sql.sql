with skills_demanded as (
SELECT 
    sd.skill_id,
    sd.skills,
    count(jpf.job_id) AS job_count
FROM
    job_postings_fact AS jpf
    inner JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
    inner JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
where
    jpf.job_title_short = 'Data Analyst'
group by
    sd.skill_id
), average_salary as (
SELECT
    sd.skill_id,
    sd.skills AS skill_name,
    round(avg(jpf.salary_year_avg),0) AS avg_salary
from 
    job_postings_fact as jpf
    inner join skills_job_dim as sjf on jpf.job_id = sjf.job_id
    inner join skills_dim as sd on sjf.skill_id = sd.skill_id
where 
    jpf.job_title_short = 'Data Analyst' AND
    jpf.salary_year_avg IS NOT NULL AND
    jpf.job_work_from_home = TRUE
group by 
    sd.skill_id
)
sELECT 
    sad.skill_id,
    sad.skills,
    sad.job_count,
    asd.avg_salary
from
    skills_demanded as sad
    inner join average_salary as asd on sad.skill_id = asd.skill_id
where
    sad.job_count > 10
order by
    sad.job_count desc,
    asd.avg_salary desc
limit 25;
    