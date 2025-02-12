use social_media_addiction;


-- first view all users with their details
SELECT
	*
FROM
	User;


-- retrieving users and their countries
SELECT
	name, country
FROM
	user
ORDER BY
	name;


-- specialization of consultants
SELECT
	distinct specialization
FROM 
	consultant;


-- username and id whose second letter is 'n' and the last is's'
SELECT
	user_id, name, age
FROM
	user
WHERE
	name LIKE '_n%s';


-- top 10 challenges by points collected 
SELECT 
	*
FROM
	challenges
ORDER BY
	points DESC
LIMIT 10;


-- activities between dates 
SELECT
	*
FROM
	activity
WHERE
	login BETWEEN '2024-01-01'AND '2024-12-31';


-- total duration for the first 15 users on all platforms
SELECT
	user_id, sum(duration)	AS	total_duration 
FROM
	activity
GROUP BY
	user_id
LIMIT 15; 


-- users who made more than 37 challenges
SELECT
	user_id, count(challenge_id) AS challenge_count
FROM
	user_challenges
GROUP BY
	user_id
HAVING 
	challenge_count > 37;


--  names of platforms and their rehab plans
SELECT
	p.name AS platform_name, 
    rp.description AS platform_plan
FROM 
	platform p,rehab_plan rp
WHERE
	p.platform_id =	rp.platform_id
ORDER BY
	p.name;


--  number of users from each country with more than 5 users
SELECT
	country AS nationality ,
    count(user_id) AS user_acount 
FROM
	user 
GROUP BY
	country
HAVING 
	count(user_id) > 5
ORDER BY
	count(user_id) DESC;


-- name of platform and total activities on each 
select
	name AS platform_name ,
	(select
		count(*) 
	from
		activity a 
	where 
		a.platform_id = p.platform_id )AS total_activities
FROM
	platform p;


-- names of consultants and total number of rehab plan supervised by them 
SELECT
	c.consultant_id,
	con.name AS consultant_name,
	count(distinct c.rehab_plan_id)AS total_rehab_plans
FROM
	consultation c
JOIN 
	consultant con ON c.consultant_id = con.consultant_id
GROUP BY
	c.consultant_id;


-- percentage of engagement on each platform
SELECT
	p.name AS platform_name,
	count(a.activity_id)AS activity_count,
	round(count(a.activity_id)*100/(select count(*)from activity ),2) AS percentage
FROM
	platform p
JOIN
	activity a ON p.platform_id=a.platform_id
GROUP BY
	p.name;


-- messages sent by users with time ,sender,and receiver names
SELECT 
    m.message_text, 
    m.sent_at, 
    (SELECT s.name FROM user s WHERE s.user_id = m.sender_id) AS sender_name,
    (SELECT r.name FROM user r WHERE r.user_id = m.reciever_id) AS receiver_name
FROM 
    message m
order by
	m.sent_at;


-- high and low addicted users
SELECT
	count(user_id) AS All_users,
	(select count(*) from high_addiction)AS high_addiction,
	(select count(*)from low_addiction)as low_addiction
from
	user;


-- users names and their engagements on different platforms
SELECT 
    U.name AS UserName,
    P.name AS PlatformName,
    E.Type,
    E.Points,
    E.Engaged_At
FROM
    user U
INNER JOIN
    Engagement E ON U.user_id = E.User_id
INNER JOIN
    Platform P ON E.Platform_id = P.Platform_id
WHERE
    E.Engaged_At > '2024-01-01';
    
    
-- users who received notifications without openning them
SELECT
	user_id,name
FROM
	user
WHERE
	user_id IN 
		(select
			distinct user_id 
		from 
			notifications
		WHERE 
			clicked_flag =0)
LIMIT 15 ; 


-- number of users who have clicked on the received notification and who haven't
SELECT 
    CASE 
        WHEN clicked_flag = 0 THEN 'Not Clicked'
        WHEN clicked_flag = 1 THEN 'Clicked'
    END AS Click_Status,
    COUNT(DISTINCT user_id) AS User_Count
FROM 
    notifications
GROUP BY 
    clicked_flag;


-- show treatment plan details for each user.
SELECT 
    u.name AS user_name,
    rp.description AS rehab_plan_description,
    rp.duration AS plan_duration
FROM 
    Consultation c
JOIN 
    user u ON c.user_id = u.user_id
JOIN 
    Rehab_plan rp ON c.rehab_plan_id = rp.rehab_plan_id
ORDER BY 
    u.name;
    
    
-- show treatment plans for users with a high level of addiction and their duration
SELECT 
    u.user_id,
    u.name,
    p.rehab_plan_id,
    p.description,
     concat(p.duration ,' days') AS duration
FROM 
    high_addiction H
JOIN 
    user u ON H.user_id = u.user_id
JOIN
consultation c ON c.user_id = H.user_id 
JOIN 
    rehab_plan p ON p.rehab_plan_id = c.rehab_plan_id ;
    
    
-- total interactions across all platforms 
SELECT 
    p.name AS platform_name,
    COUNT(e.user_id) AS engagement_count
FROM 
    Engagement e
JOIN 
    platform p ON e.platform_id = p.platform_id
GROUP BY 
    p.name
ORDER BY 
    engagement_count DESC;
    
    
-- titlt , points and number of participants per challenge
SELECT
	title AS challenge_title,
	points AS challenge_points,
		(select 
			count(uc.user_id) 
		from
			user_challenges uc 
		where
			uc.challenge_id = c.challenge_id) AS participants_count
FROM
	challenges c;


-- show Average points earned per platform
 SELECT 
    p.name AS platform_name,
    AVG(e.points) AS avg_points
FROM 
    Engagement e
JOIN 
    platform p ON e.platform_id = p.platform_id
GROUP BY 
    p.name
ORDER BY 
    avg_points DESC;
    
    
-- show name and age of users with high addiction
SELECT 
	user_id, name ,age 
FROM
	user 
WHERE
	user_id IN (SELECT user_id FROM high_addiction);
    
    
-- Top 4 Countries with the highest levels of addiction
SELECT 
    u.country,
    COUNT(ha.user_id) AS high_addiction_users
FROM 
    high_addiction ha
JOIN 
    User u ON ha.user_id = u.user_id
GROUP BY 
    u.country
ORDER BY 
    high_addiction_users DESC
limit 4;
    
    
-- The most used platform among users with a high addiction rate
SELECT 
    p.name AS platform_name,
    COUNT(e.user_id) AS usage_count
FROM 
    High_Addiction ha
JOIN 
    Engagement e ON ha.user_id = e.user_id
JOIN 
    platform p ON e.platform_id = p.platform_id
GROUP BY 
    p.name
ORDER BY 
    usage_count DESC
LIMIT 1;


-- number
select
	user.user_id,
    user.name
from
	high_addiction
left join
	user on user.user_id = high_addiction.user_id
where
	user.user_id not in (
		select 
			distinct user_id
		from
			consultation
		);

