# AC Transit Line 7 Stops and Political Boundaries

-   **get_stopr.R** (R script)
    1.  Uses the AC Transit API to fetch a list of stops for the 7 line in each direction
    2.  Looks up the addresses for each longitude/latitude pair to get the city info
    3.  Saves the info out as a file called **StopsData.rds**
-   **DisplayStopInfo.Rmd** (R Markdown script)
    1.  Runs **get_stops.R** if internal variable *Refresh* is set to TRUE

    2.  Reads in **StopsData.rds**

    3.  Uses 2 spreadsheets created by me contained in **ACTransitDirectorsFor7.zip** (**ACTransitNorthWardsCities.xlsx** and **ACTransitNorthWardsReps**) for display and to associate directors with stops for display

    4.  Produces **DisplayStopsInfo.html**, whose last version committed to Gihub can be accessed by a browser using this URL: <https://ccowens.github.io/ACTransitAPI//DisplayStopInfo.html>
