# Homework 2

Download [2018 Taxi Fare Data](https://data.cityofnewyork.us/api/views/t29m-gskq/rows.csv?accessType=DOWNLOAD).
- Source: [NYC Open Data](https://data.cityofnewyork.us/Transportation/2018-Yellow-Taxi-Trip-Data/t29m-gskq)

`create_table.sql` uses the documentation from the NYC Open Data page to create a schema for the taxi data using the defined column names.

`import_data.sql` uses COPY to import the data from the 2018 taxi csv into the **2018_Yellow_Taxi_Trip_Data** table. 