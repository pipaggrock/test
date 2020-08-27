--diferencia porcentual de ventas anuales
create or replace table `test-project-280913.derco.diff_anual` as
select AGNO, total,
round(100.00 - lag(total, 1) over (order by AGNO asc)/total*100,2) diff_perc
from (
  SELECT AGNO, count(1) as total
  FROM `test-project-280913.derco.input`
  group by AGNO
)
order by AGNO asc

--diferencia porcentual de ventas por año por marca
create or replace table `test-project-280913.derco.diff_anual_per_marca` as
select AGNO, MARCA, total,
round(100.00 - lag(total, 1) over (partition by MARCA order by AGNO asc)/total*100,2) diff_perc
from (
	SELECT AGNO, MARCA, count(1) as total
	FROM `test-project-280913.derco.input`
	group by AGNO, MARCA
)
order by AGNO asc

--creación de flag para determinar tendencias
create or replace table `test-project-280913.derco.input_enrich` as
select *,
case when flag_raise = lag(flag_raise,1) over (partition by MARCA order by AGNO asc) and flag_raise = 1 then 1 else 0 end as consecutive_raise,
case when flag_raise = lag(flag_raise,1) over (partition by MARCA order by AGNO asc) and flag_raise = 0 then 1 else 0 end as consecutive_decline,
from (
	SELECT 
	a.AGNO, 
	MARCA, 
	a.diff_perc as diff_marca, 
	b.diff_perc,
	case when a.diff_perc > 0 then 1 else 0 end as flag_raise,
	case when a.diff_perc > 0 and b.diff_perc < 0 then 1 else 0 end as flag_raise_against_global,
	case when a.diff_perc > 0 and b.diff_perc > 0 and a.diff_perc > b.diff_perc then 1 else 0 end as flag_raise_over_global,
	case when a.diff_perc < 0 and b.diff_perc > 0 then 1 else 0 end as flag_decline_against_global,
	case when a.diff_perc < 0 and b.diff_perc < 0 and a.diff_perc < b.diff_perc then 1 else 0 end as flag_decline_over_global,
	FROM `test-project-280913.derco.diff_anual_per_marca` a
	left join `test-project-280913.derco.diff_anual` b
	on a.agno=b.agno
) 
order by marca, agno

--que marcas han ido tenido tendencia de ventas en aumento
select * from (
	select marca, count(1) consecutive_times_raise, max(agno) last_year_raise
	from `test-project-280913.derco.input_enrich`
	where consecutive_raise = 1
	group by marca
) 
where last_year_raise >= 2017
order by consecutive_times_raise desc, last_year_raise desc

--que marcas han ido tenido tendencia de ventas en declive 
select * from (
select marca, count(1) consecutive_decline, max(agno) last_year_decline
from `test-project-280913.derco.input_enrich`
where consecutive_decline = 1
group by marca
) 
where last_year_decline >= 2017 and consecutive_decline > 3
order by consecutive_decline desc, last_year_decline desc