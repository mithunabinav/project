#     Introduction
📊 Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.


# Backgroung
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining the search for optimal roles.

The data originates from Luke Barousse's [SQL Course](https://lukebarousse.com/sql), covering 2023 job postings with details on job titles, locations, salaries, and required skills.
### The questions I wanted to answer through my SQL queries were
1. What were the top paying Data Analyst Job?
2. What skills were required for these top paying jobs?
3. What skills are most in demand for data analyst job?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?
# Tools I Used
**SQL:** Core querying language to extract, aggregate, and analyze job posting data.

**PostgreSQL:** Relational database management system hosting the job postings dataset.

**Visual Studio Code:** Primary code editor for writing queries and managing repository files.

**Git & GitHub:** Version control and public repository hosting for project sharing.
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:
### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.
```sql
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
```
Here's the breakdown of the top data analyst jobs in 2023:

* **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.


* **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.


* **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.


### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
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
```
Key Findings:

* SQL is the most frequent skill (appearing in 8 of 10 roles).

* Python follows closely (7 postings).

* Tableau is featured in 6 postings.
### 3. In-Demand Skills for Data Analysts
Identifies the top 5 most frequently demanded skills across all remote data analyst roles.
```sql
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
```
Top Skills by Demand:

* SQL

* Excel

* Python

* Tableau

* Power BI
### 4. Skills Based on Salary
Explores the highest average salaries associated with specific skills for remote data analysts.
```sql
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
```
Key Findings:

High-paying skills are dominated by specialized Big Data, Cloud, and ML deployment tools (e.g., PySpark, Bitbucket, Couchbase, DataRobot).
### 5. Most Optimal Skills to Learn
Finds the intersection of high demand and high salary (filtered to skills with demand count > 10).
```sql
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
```
Key Findings :
* High-Paying Programming Languages: Programming skills like Go ($115,320) and Java ($106,906) stand out with strong average compensation even within analyst roles that require custom engineering solutions.

* Cloud & Big Data Platforms Command Premiums: Cloud data warehousing and processing platforms—such as Snowflake (37 mentions, $112,948), Azure (34 mentions, $111,225), AWS (32 mentions, $108,317), and BigQuery (13 mentions, $109,654)—consistently bridge high demand with six-figure salaries.

* Data Engineering & ETL Tools: Legacy and modern data management tools like Hadoop ($113,193) and SSIS ($106,683) remain lucrative, signaling that data analysts with pipeline and extraction skills earn substantially more than pure reporting analysts.

# What I Learned
Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

* **🧩 Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.


* **📊 Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.


* **💡 Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclution
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.
