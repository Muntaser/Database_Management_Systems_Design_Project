-- capture the results into a text file to print later
--
spool C:\TPS\Team8_Workshop_Results.txt

-- setup the width and height of the page to print
--
set linesize 80;
set pagesize 64;

-- Set echo on so that you can see the input as well in the spool file
set echo on;

--
-- Team Number: 8
-- Team Members: Paul S Thong Thong, Sharjeel Khan, Tamer Maklad, Khan Muntaser
-- My SQL Statements
--

--
-- reduce the widths of column being printed
-- column cname format A10;
-- column bname format A15;
--

-- Q1: Show the name of customers who live in MPLS
-- and an account with a balance of more than
-- 1200 in any branch of the bank except the
-- France branch or customers who live in Edina
-- and have only loan and the loan is in France
-- branch.

select distinct c.cname
from customer c, account a
where c.cname = a.cname 
and lower(c.ccity) = 'mpls'
and a.bal > 1200
and lower(a.bname) != 'france'
union
select distinct c.cname
from customer c, loan l
where c.cname = l.cname
and lower(c.ccity) = 'edina'
and lower(l.bname) = 'france'
and c.cname NOT IN (select distinct cname
				    from account );
	
-- Q2: Show the name of all Customers who have an
-- account in any branches of the bank with a
-- balance of 1800 and a loan in the bank with an
-- amount of 800 using only the Exists operation	
	
select distinct a.cname
from account a
where a.bal = 1800 and
exists	(
			select l.cname
			from loan l
			where l.amt = 800
			and a.cname = l.cname
		);		
	
-- Q3: Show the branch name and assets of all
-- branches that have assets more than any assets
-- of any branch in Edina and have one or more
-- account holders living in Minnetonka and the
-- average balance of the customers account(s) is
-- more than $400.

select bname, assets
from branch 
where 
 assets > ALL (	
					select assets
					from branch  
					where lower(bcity) = 'edina'
				)
intersect
select b1.bname, assets
from account a1, branch b1 
where a1.bname = b1.bname
and a1.cname IN (select a2.cname
              from account a2, customer c1
			  where a2.cname = c1.cname 
			  and lower(ccity) = 'minnetonka'
			  group by a2.cname
			  having avg(a2.bal) > 400 );
			  
-- Q4: Find the name of all branches in Edina that
-- have assets more than 40,000 and the branch
-- has loans with a balance of more than $1000 for
-- those customers who live in Eden Prairie.
 			 
select distinct(b.bname)
from branch b, loan l, account a, customer c
where
l.bname = b.bname and
a.bname = b.bname and
c.cname = a.cname and
lower(b.bcity) = 'edina' and
b.assets > 40000 and 
a.bal > 1000 and
lower(c.ccity) = 'eden prairie';

--  Q5: Find the name of all customers who live in
--  Minnetonka and one or more accounts in any
--  branch in Edina and have a loan in every
--  branch in Edina that has assets of less than
--  100,000.

select distinct c1.cname
from customer c1, account a1
where c1.cname = a1.cname
and lower(c1.ccity) = 'minnetonka'
and a1.bname > ANY (select b1.bname
					from branch b1
					where lower(b1.bcity) = 'edina'
					)
intersect
select distinct l1.cname
from loan l1, branch b1
where l1.bname = b1.bname
and lower(b1.bcity) = 'edina'
and b1.assets < 100000
group by l1.cname
having count(l1.bname) = ALL (	select count(b2.bname)
							from branch b2
							where lower(b2.bcity) = 'edina'
							and b2.assets < 100000
							group by b2.bcity
						);
--
-- Close the spool file
spool off;
