create view daily_tip_percentage_by_distance as (
	select date_trunc('day', tpep_dropoff_datetime) as the_date,
		case when "Trip_distance" >= 0 and "Trip_distance" < 1 then '0-1 mile'
				when "Trip_distance" >= 1 and "Trip_distance" < 2 then '1-2 mile'
				when "Trip_distance" >= 2 and "Trip_distance" < 3 then '2-3 mile'
				when "Trip_distance" >= 3 and "Trip_distance" < 4 then '3-4 mile'
				when "Trip_distance" >= 4 and "Trip_distance" < 5 then '4-5 mile'
				when "Trip_distance" >= 5 then '5+ mile'
		end as trip_mileage_band,
		(round(avg("Tip_amount"/"Total_amount") * 100, 2) || '%') as tip_percentage
	from "2018_Yellow_Taxi_Trip_Data"
	where extract (year from tpep_dropoff_datetime) = 2018 and "Total_amount" > 0 --account for division by zero error
	group by the_date, trip_mileage_band);

    select * from daily_tip_percentage_by_distance; --outputs the view