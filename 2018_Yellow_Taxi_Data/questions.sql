/*1*/
select count(*) from "2018_Yellow_Taxi_Trip_Data" where "passenger_count" = 5; --5,040,905

/*2*/
select count(*) from (select distinct * from "2018_Yellow_Taxi_Trip_Data") x 
    where "passenger_count" > 3; --9,415,989

/*3*/
select count(*) from "2018_Yellow_Taxi_Trip_Data" 
    where "tpep_pickup_datetime" between '2018-04-01 00:00:00' and '2018-05-01 00:00:00'; --9,305,362

/*4*/
select count(*) from (select distinct * from "2018_Yellow_Taxi_Trip_Data") x 
    where "tpep_pickup_datetime" between '2018-06-01 00:00:00' and '2018-06-30 23:59:59' 
    and "tip_amount" >= 5; --713,388

/*5*/
select count(*) from (select distinct * from "2018_Yellow_Taxi_Trip_Data") x 
    where "tpep_pickup_datetime" between '2018-05-01 00:00:00' and '2018-05-31 23:59:59' 
    and "passenger_count" > 3 
    and "tip_amount" between 2 and 5; --236,457

/*6*/
select sum("tip_amount") from "2018_Yellow_Taxi_Trip_Data"; --210,156,392.48