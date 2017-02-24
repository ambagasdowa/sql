select 1557.68 + 0.08 ;

select CAST(1557.68 AS DECIMAL(10,2))+ CAST(0.08 AS DECIMAL(10,2)) i_decimal ;

select CAST(1557.68 AS REAL)+ CAST(0.08 AS REAL) i_real;

select CAST(1557.68 AS FLOAT)+ CAST(0.08 AS FLOAT) i_float;

select CAST(1557.68 AS FLOAT)+ CAST(0.08 AS REAL) i_float_real;

select CAST(1557.68 AS REAL)+ CAST(0.08 AS FLOAT) i_real_float;


select CAST(1557.68 AS INT)+ CAST(0.08 AS INT) i_int ;