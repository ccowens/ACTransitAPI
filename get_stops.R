# Packages ----------------------------------------------------------------

if(!require(curl)) {install.packages("curl"); library(curl)}
if(!require(jsonlite)) {install.packages("jsonlite"); library(jsonlite)}
if(!require(xml2)) {install.packages("xml2"); library(xml2)}
if(!require(dplyr)) {install.packages("dplyr"); library(dplyr)}
if(!require(XML)) {install.packages("XML"); library(XML)}
if(!require(stringr)) {install.packages("stringr"); library(stringr)}
if(!require(tidygeocoder)) {install.packages("tidygeocoder"); library(tidygeocoder)}

# Functions ---------------------------------------------------------------
get_stops <- function(line, direction) {
  response <- curl_fetch_memory(paste0(baseUrl, "route/", line, "/stops?direction=", direction, "&token=", myToken), myHandle)
  xml_doc <- read_xml(response$content)
  root_node <- xml_root(xml_doc)
  xml_attrs(root_node) <- NULL
  
  # Extract all relevant nodes 
  nodes <- xml_find_all(xml_doc, "//RouteStopOrder.StopOrder") 
  # Convert nodes to a list of character vectors 
  data_list <- lapply(nodes, 
                      function(node) 
                      { children <- xml_children(node) 
                      sapply(children, xml_text) })
  # Convert list to a DataFrame 
  df <- bind_cols(lapply(data_list, as.data.frame)) %>% 
    t() %>% 
    as.data.frame() 
  colnames(df) <- c("Latitude","Longitude","Stop Name", "Sequence Number", "Stop Number")
  rownames(df) <- NULL
  
  df %>%
    mutate(Longitude = as.numeric(Longitude), Latitude = as.numeric(Latitude)) %>% 
    reverse_geocode(lat = Latitude, long = Longitude, addr = Address) %>% 
    mutate(City = str_extract(Address, "(?<=, )[A-Za-z ]+(?=, [A-Za-z ]+ County)"),
           Direction = direction,
           Line = line) %>% 
    select("Stop Number", Line, Direction, "Sequence Number", "Stop Name", City, Address, Latitude, Longitude)
  }


# Setup -------------------------------------------------------------------
myToken <- Sys.getenv("MY_ACTRANSITAPI_TOKEN")
baseUrl <- "https://api.actransit.org/transit/"
  
myHandle <- new_handle()
handle_setheaders(myHandle, Accept = "application/xml")

# Main --------------------------------------------------------------------

bind_rows(get_stops("7", "Southbound"), get_stops("7", "Northbound")) %>% 
saveRDS("StopsData.rds")

