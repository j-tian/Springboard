/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
SELECT * 
FROM  `Facilities` 
WHERE  `membercost` >0
LIMIT 0 , 30

Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court

/* Q2: How many facilities do not charge a fee to members? */
SELECT COUNT( * ) 
FROM  `Facilities` 
WHERE  `membercost` =0

4

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT  `facid` ,  `name` ,  `membercost` ,  `monthlymaintenance` 
FROM  `Facilities` 
WHERE  `membercost` >0
AND  `membercost` < 0.2 *  `monthlymaintenance` 
LIMIT 0 , 30

facid	name	membercost	monthlymaintenance	
0	Tennis Court 1	5.0	200
1	Tennis Court 2	5.0	200
4	Massage Room 1	9.9	3000
5	Massage Room 2	9.9	3000
6	Squash Court	3.5	80



/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
SELECT * 
FROM  `Facilities` 
WHERE  `facid` 
IN ( 1, 5 ) 
LIMIT 0 , 30


name	facid	membercost	guestcost	initialoutlay	monthlymaintenance	
Tennis Court 2	1	5.0	25.0	8000	200
Massage Room 2	5	9.9	80.0	4000	3000


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT  `name` ,  `monthlymaintenance` , 
CASE WHEN  `monthlymaintenance` >100
THEN  'expensive'
ELSE  'cheap'
END AS price
FROM  `Facilities` 
LIMIT 0 , 30

name	monthlymaintenance	price	
Tennis Court 1	200	expensive
Tennis Court 2	200	expensive
Badminton Court	50	cheap
Table Tennis	10	cheap
Massage Room 1	3000	expensive
Massage Room 2	3000	expensive
Squash Court	80	cheap
Snooker Table	15	cheap
Pool Table	15	cheap

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
SELECT  `firstname` ,  `surname` 
FROM  `Members` 
WHERE  `joindate` 
IN (

SELECT MAX(  `joindate` ) 
FROM  `Members`
)


firstname	surname	
Darren	Smith

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT CONCAT(  `Members`.`surname` ,  ',',  `Members`.`firstname` ) ,  `Facilities`.`name` 
FROM  `Bookings` 
JOIN  `Members` ON  `Bookings`.`memid` =  `Members`.`memid` 
JOIN  `Facilities` ON  `Bookings`.`facid` =  `Facilities`.`facid` 
WHERE  `Facilities`.`facid` 
IN ( 0, 1 ) 
GROUP BY  `Bookings`.`starttime` 
ORDER BY  `Members`.`surname` 
LIMIT 0 , 30


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT CONCAT( `Members`.`surname` , ',', `Members`.`firstname` ) , `Facilities`.`name` , `Bookings`.`starttime`,
CASE WHEN `Bookings`.`memid` >0
THEN `Bookings`.`slots` * `Facilities`.`membercost` 
ELSE `Bookings`.`slots` * `Facilities`.`guestcost` 
END AS cost
FROM `Bookings` 
JOIN `Members` ON `Bookings`.`memid` = `Members`.`memid` 
JOIN `Facilities` ON `Bookings`.`facid` = `Facilities`.`facid` 
WHERE `Bookings`.`starttime` between '2012-09-14' and '2012-09-14 23:59:59'
HAVING cost >30
ORDER BY cost DESC

LIMIT 0 , 30
 


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT CONCAT(  `Members`.`surname` ,  ',',  `Members`.`firstname` ) ,  `Facilities`.`name` , 
CASE WHEN t1.`memid` >0
THEN t1.`slots` *  `Facilities`.`membercost` 
ELSE t1.`slots` *  `Facilities`.`guestcost` 
END AS cost
FROM (

SELECT * 
FROM  `Bookings` 
WHERE  `starttime` 
BETWEEN  '2012-09-14 00:00:00'
AND  '2012-09-14 23:59:59'
)t1
JOIN  `Members` ON t1.`memid` =  `Members`.`memid` 
JOIN  `Facilities` ON t1.`facid` =  `Facilities`.`facid` 
HAVING cost >30
ORDER BY cost DESC 
LIMIT 0 , 30



/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT  `Facilities`.`name` , SUM( 
CASE WHEN  `Bookings`.`memid` >0
THEN  `Bookings`.`slots` *  `Facilities`.`membercost` 
ELSE  `Bookings`.`slots` *  `Facilities`.`guestcost` 
END ) AS revenue
FROM  `Bookings` 
JOIN  `Members` ON  `Bookings`.`memid` =  `Members`.`memid` 
JOIN  `Facilities` ON  `Bookings`.`facid` =  `Facilities`.`facid` 
GROUP BY  `Facilities`.`name` 
HAVING revenue <1000
ORDER BY revenue DESC 
LIMIT 0 , 30
