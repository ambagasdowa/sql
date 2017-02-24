use integraapp;

select 
        Acct
        ,Sub
        --,sum(cramt)as 'cr',sum(dramt) as 'dr'
        ,sum(curydramt)as 'curycr',sum(curycramt) as 'curydr'
        --,sum(curycramt - curydramt) as 'real'
        ,sum(curydramt - curycramt) as 'real'
from integraapp.dbo.GLTran 
where Acct = '0601170700' and perpost = '201701' and CpnyID = 'TBKORI' and posted = 'P'

group by 
        Acct
        ,Sub
        
-- ============================================= --

select 
        Acct
        ,Sub
        ,sum(curydramt),sum(curycramt)
        ,sum(curydramt - curycramt) as 'real'
        --,curydramt,curycramt
        --,(curydramt - curycramt) as 'real'
from integraapp.dbo.GLTran 
where Acct = '0601170700' and perpost = '201701' and CpnyID = 'TBKORI' and posted = 'P'
      and sub = '000000000AB    000000   '
      and Trandesc = 'CONSUMO'
group by Acct, Sub


select sum(Cargo-Abono) from sistemas.dbo.mr_source_reports_temps
where nocta = '0601170700' and _key = 'AD' and _period = '201701'
      and Entidad = '000000000AB    000000   '
and _company not in ('TEICUA','TCGTUL','ATMMAC')
--and Descripción = 'CONSUMO'

