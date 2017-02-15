---
output:
  word_document: default
  pdf_document: default
  html_document: default
---
### Flight delays in the NYC area

#### Introduction

Hadley Wickham, Chief Scientist at RStudio, has collected airline on-time data for all flights departing New York City (NYC) in 2013. The airports covered by the data are LaGuardia Airport (LGA), John F. Kennedy International Airport (JFK) and Newark International Airport (EWR).

In this project, we use these data to evaluate the occurrence of flight delay in the NYC aerea and the extent to which it can be predicted from the available data. Departure delay can be measured in a continuous time scale (e.g. in minutes) or as a binary variable (it is frequently considered that a flight is delayed when the delay exceeds 15 minutes, but other cutoffs can be tried).

#### The data sets

The database includes five tables. In the last three tables, the data are not complete.

* The `airlines` table contains the look up airline names (16) from their carrier codes: 

    + The two letter abbreviation (`carrier`). 
    
    + The full name of the carrier (`name`).

* The `airports` table contains metadata for all the airports (1,458) connected with the NYC area: 

    + The FAA airport code (`faa`).
    
    + The usual name of the aiport (`name`). 
    
    + The coordinates of the location of the airport (`lat`, `lon`). 
    
    + The altitude in feet (`alt`)
    
    + The timezone offset from GMT (`tz`). 
    
    + The daylight savings time zone (`dst`). A denotes the Standard US DST, starting on the second Sunday of March and ending on the first Sunday of November, U stands for unknown and N for non-existing dst). 
    
    + The IANA time zone, as determined by GeoNames webservice (`tzone`).

* The `flights` table contains on-time data for all flights (336,776) that departed the NYC area in 2013: 

    + Scheduled date and hour of the flight as a POSIXct date in the local time zone (`datetime`).
    
    + Actual departure and arrival times (`dep_time`, `arr_time`).
    
    + Scheduled departure and arrival times (`sched_dep_time`, `sched_arr_time`).
    
    + Departure and arrival delays in minutes (`dep_delay`, `arr_delay`), with negative times representing early departures/arrivals.
    
    + Two-letter carrier abbreviation (`carrier`).
    
    + Plane tail number (`tailnum`).
    
    + Flight number (`flight`).
    
    + Origin and destination (`origin`, `dest`).
    
    + Amount of time spent in the air in minutes (`air_time`).
    
    + Distance between airports in miles (`distance`).

* The `planes` table contains plane metadata for all plane tailnumbers (3,322) found in the FAA aircraft registry: 

    + The tail number (`tailnum`).
    
    + The year manufactured (`year`).
    
    + The type of plane (`type`).
    
    + The manufacturer and model (`manufacturer`, `model`).
    
    + The number of engines and seats (`engines`, `seats`).
    
    + The average cruising speed in mph (`speed`).
    
    + The type of engine (`engine`). 

* The `weather` table contains hourly meterological data for LGA, JFK and EWR: 

    + The weather station (`origin`).
    
    + The date and hour of the recording as a POSIXct date (`datetime`).
    
    + The temperature and dewpoint in Farenheit (`temp`, `dewp`).
    
    + The relative humidity (`humid`).
    
    + The wind direction in degrees, speed and gust speed in mph (`wind_dir`, `wind_speed`, `wind_gust`).
    
    + The precipitation in inches (`precip`).
    
    + The sea level pressure in millibars (`pressure`).
    
    + The visibility in miles (`visib`).
    
#### Lines of analysis

* Examine the occurrence of missing data in these data sets. Can they be taken as "missing at random"?

* Are there seasonal patterns in the departure delays?

* How feasible it is to predict the departure delay in a continous scale? Or is it better to drop this approach and use a binary scale?

* Does the destination make a difference with respect to departure delay? Or is better to regard it as a question on whether an airline is more or less reliable?

* Can bad weather be taken as a cause of departure delay in the NYC area?

* Is there a characteristic of the planes that makes delay more likely to happen?

* To which extent can departure delay be predicted from the data available here?

#### Sources

1. OpenFlights.org.

2. RITA, Bureau of Transportation Statistics.

3. FAA Aircraft Registry.

4. ASOS Network download from Iowa Environmental Mesonet.
