<style>
.section .reveal .state-background {
    background: #73b300;}
</style>

ParkrunUKFinder App
========================================================
author: Nathalie Descusse-Brown
date: 29th April 2019
autosize: true
***
![Parkrun Logo](160517-Parkrun.png)

What is ParkRun?
========================================================
<font size="8">  
Parkrun is a series of 5k runs held on Saturday mornings in areas of open space around the UK. They are open to all, free, and are safe and easy to take part in. 

They are so popular than a phenomenon appeared in the form of the ParkRun alphabet where participants try and run ParkRuns to cover all letters of the alphabet. 

This app is designed to make it easier for them to find a nearby ParkRun starting by the letter of their choice!
</font> 

<h2>
How does the ParkrunFinder app work?
</h2>

<font size="8">  
The ParkrunFinder app works by scrapping the https://en.wikipedia.org/wiki/List_of_Parkruns_in_the_United_Kingdom website. Before doing so, a check was performed with the R package robotstxt to ensure scraping of this site was allowed.
</font> 

What the app looks like
========================================================
The left hand side gives instructions for use and has a box for free text input of postcode and dropdown menu
for selection of first letter of ParkRun event town.

![alt text](appscreenshot.jpg)


How to use the app
========================================================
 
1. Enter your postcode
2. Enter the letter of interest (if you want to return all ParkRuns then just select 'All')
3. Maximise the app window to ensure you can view the results that will appear on the right hand side.
4. Wait for about 10-15 seconds for the results to be returned
5. Once the results are returned, you can filter them further by using the search function at the top right hand side of the results table."),

Please note that some towns will not have latitudes and longitudes associated with them in the original wikipedia page used for this app, making it impossible to calculate the distance from the user postcode. These ParkRuns locations are nevertheless returned at the bottom of the results table. 
Please also note distances are calculated as as-the-crow-flies distances.

The back end of the app
========================================================


```r
source('C:/Users/natha/Developing_Data_Products/ParkRunFinderPlus/findParkrunUKplusdistance.R')
results <- findParkrunUKplusdistance("SW20 9EE")
head(results[order(results[,6]),c(1,6)])
```

```
                      Name Distance in miles
383        Nonsuch parkrun          2.300383
130  Fulham Palace parkrun          4.930503
121          Bushy parkrun          5.042152
118      Brockwell parkrun          6.189142
126 Crystal Palace parkrun          6.818224
127        Dulwich parkrun          7.082410
```

