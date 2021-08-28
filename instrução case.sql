**CASE;**

select year, month, day, wind_speed,
case
when wind_speed >= 40 then 'High'
when wind_speed >=30 and wind_speed < 40 then 'Moderate'
else 'Low'
end as wind_severity
from station_data
order by year;


select year,
case
when wind_speed >= 40 then 'High'
when wind_speed >=30 then 'Moderate'
else 'Low'
end as wind_severity,
count(*) as record_count
from station_data
group by 1,2;


select year,month,
sum(case when tornado = 1 then precipitation else 0 end) as tornado_precipitation,
sum(case when tornado = 0 then precipitation else 0 end) as non_tornado_precipitation
from station_data
group by year,month;


select year,
max(case when tornado = 1 then precipitation else null end) as max_tornado_precipitation,
max(case when tornado = 0 then precipitation else null end) as max_non_tornado_precipitation
from station_data
group by year;


select month,
avg(case when rain or hail then temperature else null end) as avg_precipitation_temperature,
avg(case when not (rain or hail) then temperature else null end) as avg_non_precipitation_temperature
from station_data
group by month;