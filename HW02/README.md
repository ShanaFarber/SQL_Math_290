# Homework 2

Source and documentation: [NYC Open Data](https://data.cityofnewyork.us/Transportation/2018-Yellow-Taxi-Trip-Data/t29m-gskq) (export as CSV and use data dictionary PDF to define columns).

### SQL Scripts

1. `create_table.sql` uses the documentation from the NYC Open Data page to create a schema for the taxi data using the defined column names.
2. `import_data.sql` uses COPY to import the data from the 2018 taxi csv into the **2018_Yellow_Taxi_Trip_Data** table. Taxi data CSV stored in "Temp" file so that Postgres server can access.