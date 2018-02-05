-- capture the results into a text file to print later
--
spool C:\TPS\Team8_Create_View_Results.txt

-- setup the width and height of the page to print
--
set linesize 80;
set pagesize 64;

-- Set echo on so that you can see the input as well in the spool file
set echo on;

--
-- Team Number: 8
-- Team Members: Paul S Thong Thong, Sharjeel Khan, Tamer Maklad, Khan Muntaser
-- Create view  SQL Statements
--

--
-- reduce the widths of column being printed
-- column cname format A10;
-- column bname format A15;
--

-- 1.	Ents_2hops: 
-- This view returns the name of every entity and 
-- (or entities) that are related to the 2 hops away

CREATE VIEW ENTS_2HOPS
(
    RESULT
)
AS
    SELECT DISTINCT
           CASE
               WHEN r1_left.ENAME > r2_right.ename
               THEN
                   (r2_right.ENAME || ',' || r1_left.ename)
               WHEN r1_left.ENAME < r2_right.ename
               THEN
                   (r1_left.ENAME || ',' || r2_right.ename)
           END
               AS result
      FROM relates  r1_left,
           relates  r1_right,
           relates  r2_left,
           relates  r2_right
     WHERE     -- must be same relationship r1
	           r1_left.RNAME = r1_right.RNAME 
               -- r1 connects 2 differents entities a and b			   
           AND r1_left.ENAME != r1_right.ENAME
               -- must be same relationship r2		   
           AND r2_left.RNAME = r2_right.RNAME
               -- r2 connects 2 differents entities b and c		   
           AND r2_left.ENAME != r2_right.ENAME 
		       -- r1 and r2 intersect b
           AND r1_right.ENAME = r2_left.ENAME
               -- a is different to b		   
           AND r1_left.ENAME != r2_right.ENAME 
		       -- r1 is not r2
           AND r1_left.RNAME != r2_right.RNAME;
	
-- 2.	Ents_2hops_attr: Repeat question 1 but this time print
--      not only the name of the related entities but also the 
--      attributes of these entities. You will get extra credit 
--      if you can print all the attributes of the related entities on one line	
	
CREATE VIEW ENTS_2HOPS_ATTR
(
    RESULT
)
AS
    WITH temp
         AS (SELECT REGEXP_SUBSTR (e.RESULT,
                                   '[^,]+',
                                   1,
                                   1)
                        AS e1,
                    REGEXP_SUBSTR (e.RESULT,
                                   '[^,]+',
                                   1,
                                   2)
                        AS e2
               FROM ENTS_2HOPS e)
      SELECT    t.E1
             || ','
             || t.E2
             || ','
             || LISTAGG (c.ANAME, ',') WITHIN GROUP (ORDER BY c.ANAME)
                 AS attribs
        FROM temp t, contains c
       WHERE t.E2 = c.ENAME
    GROUP BY t.E1, t.E2;	
	
-- 3.	Rel_2Ent: This view returns the name of each relationship and 
--      the entity names connected to the relationship for those relationships 
--      that connect to only 2 entities and these entities have more than 2 attributes each

CREATE VIEW REL_2ENT
(
    RNAME,
    ENAME
)
AS
    SELECT r.rname, r.ENAME
      FROM relates r
     WHERE     r.ename IN (  SELECT c.ENAME
                               FROM contains c
                           GROUP BY c.ENAME
                             HAVING COUNT (c.ANAME) > 2)
           AND r.RNAME IN (  SELECT r.rname
                               FROM relates r
                           GROUP BY r.RNAME
                             HAVING COUNT (DISTINCT r.ename) = 2);

			  
-- 4.	Spec_Super_Ent: This view returns the name of each specialization, 
--      the super type entity name and its attributes
 			 
CREATE VIEW SPEC_SUPER_ENT
(
    SNAME,
    ENAME,
    ANAME
)
AS
    SELECT sp.SNAME, sp.ENAME, c.ANAME
      FROM specialization sp, contains c
     WHERE sp.sname = c.ENAME;

--  5.	Spec_Sub_Ents: This view returns the name of each specialization,
--      the sub_type entity names and their attributes.

CREATE VIEW SPEC_SUB_ENTS
(
    SNAME,
    ENAME,
    ANAME
)
AS
    SELECT s.SNAME, s.ENAME, c.ANAME
      FROM sub s, contains c
     WHERE s.sname = c.ENAME;

--
-- Close the spool file
spool off;
