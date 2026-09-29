SELECT 
    sd.skills,
    count(jpf.job_id) AS job_count
FROM
    job_postings_fact AS jpf
    inner JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
    inner JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
where
    jpf.job_title_short = 'Data Analyst'
group by
    sd.skills
order by
    job_count DESC    
limit 5;