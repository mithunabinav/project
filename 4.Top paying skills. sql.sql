SELECT
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
    sd.skills
ORDER BY
    avg_salary DESC
LIMIT 25;