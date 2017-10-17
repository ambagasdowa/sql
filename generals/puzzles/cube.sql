
--Below are three separate implementations for each of SQL Server, MySQL and Oracle. None use (or can) the same approach, so there doesn't seem to be a cross DBMS way to do it. For MySQL and Oracle, only the simple integer test is show; for SQL Server, the full numeric test is shown.
--
--For SQL Server: note that isnumeric('.') returns 1.. but it can not actually be converted to float. Some text like '1e6' cannot be converted to numeric directly, but you can pass through float, then numeric.

;with tmp(x) as (
    select 'db01' union all select '1' union all select '1e2' union all
    select '1234' union all select '' union all select null union all
    select '1.2e4' union all select '1.e10' union all select '0' union all
    select '1.2e+4' union all select '1.e-10' union all select '1e--5' union all
    select '.' union all select '.123' union all select '1.1.23' union all
    select '-.123' union all select '-1.123' union all select '--1' union all
    select '---1.1' union all select '+1.123' union all select '++3' union all
    select '-+1.123' union all select '1 1' union all select '1e1.3' union all
    select '1.234' union all select 'e4' union all select '+.123' union all
    select '1-' union all select '-3e-4' union all select '+3e-4'  union all
    select '+3e+4' union all select '-3.2e+4' union all select '1e1e1' union all
    select '-1e-1-1')

select x, isnumeric(x),
    case when x not like '%[^0-9]%' and x >'' then convert(int, x) end as SimpleInt,
    case
    when x is null or x = '' then null -- blanks
    when x like '%[^0-9e.+-]%' then null -- non valid char found
    when x like 'e%' or x like '%e%[e.]%' then null -- e cannot be first, and cannot be followed by e/.
    when x like '%e%_%[+-]%' then null -- nothing must come between e and +/-
    when x='.' or x like '%.%.%' then null -- no more than one decimal, and not the decimal alone
    when x like '%[^e][+-]%' then null -- no more than one of either +/-, and it must be at the start
    when x like '%[+-]%[+-]%' and not x like '%[+-]%e[+-]%' then null
    else convert(float,x)
    end
from tmp order by 2, 3


--For MySQL

create table tmp(x varchar(100));
insert into tmp
    select 'db01' union all select '1' union all select '1e2' union all
    select '1234' union all select '' union all select null union all
    select '1.2e4' union all select '1.e10' union all select '0' union all
    select '1.2e+4' union all select '1.e-10' union all select '1e--5' union all
    select '.' union all select '.123' union all select '1.1.23' union all
    select '-.123' union all select '-1.123' union all select '--1' union all
    select '---1.1' union all select '+1.123' union all select '++3' union all
    select '-+1.123' union all select '1 1' union all select '1e1.3' union all
    select '1.234' union all select 'e4' union all select '+.123' union all
    select '1-' union all select '-3e-4' union all select '+3e-4'  union all
    select '+3e+4' union all select '-3.2e+4' union all select '1e1e1' union all
    select '-1e-1-1';

select x,
    case when x not regexp('[^0-9]') then x*1 end as SimpleInt
from tmp order by 2

--For Oracle

case when REGEXP_LIKE(col, '[^0-9]') then col*1 end

-- =========================================== Puzzle =================================================== --

declare @Puzzle as Table (
							  id int identity, Y int, X int
  						   )
INSERT INTO @Puzzle VALUES
  (1,1),(1,2),(1,8),(1,9),(1,10),
  (2,2),(2,3),(2,8),(2,9),
  (3,9),
  (4,3),(4,4),
  (5,7),(5,8),(5,9),
  (6,5)

--select * from @Puzzle
  
with Walker(StartX,StartY,X,Y,Visited) as (
    select X,Y,X,Y,CAST('('+right(X,3)+','+right(Y,3)+')' as Varchar(Max))
    from @Puzzle as "puzzle"
    union all
    select W.StartX,W.StartY,P.X,P.Y,W.Visited+'('+right(P.X,3)+','+right(P.Y,3)+')'
    from Walker W
    join Puzzle P on
      (W.X=P.X   and W.Y=P.Y+1 OR   -- these four lines "collect" a cell next to
       W.X=P.X   and W.Y=P.Y-1 OR   -- the current one in any direction
       W.X=P.X+1 and W.Y=P.Y   OR
       W.X=P.X-1 and W.Y=P.Y)
      AND W.Visited NOT LIKE '%('+right(P.X,3)+','+right(P.Y,3)+')%'
)
select X, Y, Visited
from
(
    select W.X, W.Y, W.Visited, rn=row_number() over (
                                   partition by W.X,W.Y
                                   order by len(W.Visited) desc)
    from Walker W
    left join Walker Other
        on Other.StartX=W.StartX and Other.StartY=W.StartY
            and (Other.Y<W.Y or (Other.Y=W.Y and Other.X<W.X))
    where Other.X is null
) Z
where rn=1