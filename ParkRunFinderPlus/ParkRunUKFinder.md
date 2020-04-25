<style>
.section .reveal .state-background {
    background: #73b300;}
</style>

ParkrunUKFinder App
========================================================
author: Nathalie Descusse-Brown
date: 29th April 2019
autosize: true
css: MySlideTemplate.css

<div align="bottom">
<img src="160517-Parkrun.png" width=650 height=420 margin=0>
</div>

<style>
.reveal .slides section .slideContent h2{
    font-size: 28pt;
    color: #73b300;
}
</style>
What is ParkRun? 
========================================================
title: false
css: MySlideTemplate.css
<h2>What is Parkrun?</h2>
<font size="4.5">Parkrun is a series of free 5k runs held on Saturday mornings in areas of open space around the UK. 
They are so popular than a phenomenon appeared in the form of the ParkRun alphabet where participants try and run ParkRuns in different towns starting with each letter of the alphabet. 
This app is designed to make it easier for them to find a nearby ParkRun starting by the letter of their choice!
</font> 
<h2>
How does the ParkrunFinder app work?
</h2>
<font size="4.5">
- Scrapes https://en.wikipedia.org/wiki/List_of_Parkruns_in_the_United_Kingdom website. A check was performed with the R package robotstxt to ensure scraping of this site was allowed.
- Returns the list of all parkruns.
- Interrogates associated hyperlinks (town's page in wiki) to look up associated latitude/longitude. 
- Looks up latitude/longitude of user-entered postcode by looking it up in table downloaded from https://www.freemaptools.com/download-uk-postcode-lat-lng.htm.
- Calculates haversine ('as-the-crow-flies') distance between Parkrun location and user postcode. 
- Returns list of Parkruns ordered by distance from the user postcode. 
- User can filter further by selecting first letter of Parkrun location, in order to tick it off own Parkrun alphabet!

</font> 


What the app looks like
========================================================
title:false

<h2>
What the app looks like
</h2>

<font size="4.5">
The left hand side gives instructions for use and has a box for free text input of postcode and dropdown menu
for selection of first letter of ParkRun event town.
</font>

<div align="center">
<img src="appscreenshot.jpg" width=1200 height=550>
</div>

<style>
.reveal .slides section .slideContent ol {
font-size: "4.5";
} 
</style>

How to use the app
========================================================
title:false

<h2>
How to use the app
</h2>

1. Enter your postcode.
2. Enter the letter of interest (if you want to return all ParkRuns then just select 'All').
3. Maximise the app window to ensure you can view the results that will appear on the right hand side.
4. Wait for about 10-15 seconds for the results to be returned.
5. Once the results are returned, you can filter them further by using the search function at the top right hand side of the results table.").
 
<h3>
<font size="4.5">
Please note that some towns will not have latitudes and longitudes associated with them in the original wikipedia page used for this app, making it impossible to calculate the distance from the user postcode. These ParkRuns locations are nevertheless returned at the bottom of the results table. 
Please also note distances are calculated as as-the-crow-flies distances.
</font>
</h3>

<style>
.small-code pre code {
  font-size: 1em;
}
</style>
The back end of the app
========================================================
title:false
class: small-code

<h2>
The back end of the app
</h2>

<font size="4.5">
The example of code below shows some of the results displayed by the app, and in particular what is returned by the main app function, findParkrunUKplusdistance.R. For clarity in this presentation, only the Parkrun location name and distance from user-entered postcode for the closest 10 locations is shown, but the app returns additional information related to each Parkrun.
</font>



```r
source('C:/Users/natha/Developing_Data_Products/ParkRunFinderPlus/findParkrunUKplusdistance.R')
results <- findParkrunUKplusdistance("SW15 3TR")
head(results[order(results[,6]),c(1,6)],5)
```

```
                     Name Distance in miles
130 Fulham Palace parkrun          1.620577
118     Brockwell parkrun          5.244188
121         Bushy parkrun          5.286177
383       Nonsuch parkrun          5.691658
127       Dulwich parkrun          6.490548
```

