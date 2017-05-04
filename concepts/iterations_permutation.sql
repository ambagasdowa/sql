declare @s as varchar(5)
set @s = 'ABCDE';




with Subsets as(
	select
		cast(
			substring( @s, number, 1 ) as varchar(5)
		) as Token,
		cast(
			'.' + cast(
				number as char(1)
			)+ '.' as varchar(11)
		) as Permutation,
		cast(
			1 as int
		) as Iteration
	from
		dbo.Numbers
	where
		number between 1 and 5
union all select
		cast(
			Token + substring( @s, number, 1 ) as varchar(5)
		) as Token,
		cast(
			Permutation + cast(
				number as char(1)
			)+ '.' as varchar(11)
		) as Permutation,
		s.Iteration + 1 as Iteration
	from
		Subsets s join dbo.Numbers n on
		s.Permutation not like '%.' + cast(
			number as char(1)
		)+ '.%'
		and s.Iteration < 5
		and number between 1 and 5 --AND s.Iteration = (SELECT MAX(Iteration) FROM Subsets)

) select
	*
from
	Subsets
where
	Iteration = 5
order by
	Permutation

	
	
with llb as(
	select
		'A' as col,
		1 as cnt
union select
		'B' as col,
		3 as cnt
union select
		'C' as col,
		9 as cnt
union select
		'D' as col,
		27 as cnt
) select
	a1.col,
	a2.col,
	a3.col,
	a4.col
from
	llb a1 cross join llb a2 cross join llb a3 cross join llb a4
where
	a1.cnt + a2.cnt + a3.cnt + a4.cnt = 40