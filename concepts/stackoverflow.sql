-- ============================================ stackoverflow ================================================= --

--Is it possible to use between operator within a CASE statement within a WHERE Clause ?
--For example in the code below, the condition should be pydate between (sysdate-12) and (sysdate-2)
--if its a monday and pydate between (sysdate-11) and (sysdate-1) if its a tuesday and so on.
--But the following doesn't work. May be there is another way of writing this. Can someone please help ?
select * from table_name
  where pricekey = 'JUF'
  and
 		case
 			when to_char(to_date(sysdate,'DD-MON-YY'), 'DY')='MON'
 				then pydate between to_date(sysdate-12,'DD-MON-YY') and to_date(sysdate-2,'DD-MON-YY')
			when to_char(to_date(sysdate,'DD-MON-YY'), 'DY')='TUE'
				then pydate between to_date(sysdate-11,'DD-MON-YY') and to_date(sysdate-1,'DD-MON-YY')
			else pydate='sysdate'
 		end
--You can apply the logic you are attempting, but it is done without the CASE. Instead, you need to create logical groupings of OR/AND to
--combine the BETWEEN with the other matching condition from your case.
--This is because CASE is designed to return a value, rather than to dynamically construct the SQL inside it.

SELECT *
FROM  table_name
WHERE
  pricekey = 'JUF'
  AND
    (
  		    -- Condition 1
  		    (
  		    	to_char(to_date(sysdate,'DD-MON-YY'), 'DY') = 'MON'
  		    	AND pydate BETWEEN to_date(sysdate-12,'DD-MON-YY') AND to_date(sysdate-2,'DD-MON-YY')
  		    )
  		    -- Condition 2
  		    OR
  		    (
  		    	to_char(to_date(sysdate,'DD-MON-YY'), 'DY')='TUE'
  		    	AND pydate BETWEEN to_date(sysdate-11,'DD-MON-YY') AND to_date(sysdate-1,'DD-MON-YY')
  		    )
  		    -- ELSE case, matching neither of the previous 2
  		    OR
  		    (
  		    	to_char(to_date(sysdate,'DD-MON-YY'), 'DY') NOT IN ('MON', 'TUE') AND pydate = 'sysdate'
  		    )
  		)
