if(!require(curl)) {install.packages("curl"); library(curl)}
if(!require(jsonlite)) {install.packages("jsonlite"); library(jsonlite)}
if(!require(xml2)) {install.packages("xml2"); library(xml2)}
if(!require(dplyr)) {install.packages("dplyr"); library(dplyr)}
if(!require(XML)) {install.packages("XML"); library(XML)}
if(!require(stringr)) {install.packages("stringr"); library(stringr)}


myToken <- "859CB1FE286DD9FA62741422C7C50162"
baseUrl <- "https://api.actransit.org/transit/"
  
myHandle <- new_handle()
handle_setheaders(myHandle, Accept = "application/xml")

myCommand <- "route/7/stops?direction=Southbound&"

response <- curl_fetch_memory(paste0(baseUrl,myCommand,"token=", myToken), myHandle)

xml_doc <- read_xml(response$content)
root_node <- xml_root(xml_doc)
xml_attrs(root_node) <- NULL

# Extract all relevant nodes 
nodes <- xml_find_all(xml_doc, "//RouteStopOrder.StopOrder") 
# Convert nodes to a list of named vectors 
data_list <- lapply(nodes, 
                      function(node) 
                        { children <- xml_children(node) 
                        sapply(children, xml_text) })
# Convert list to a DataFrame 
df <- bind_cols(lapply(data_list, as.data.frame)) %>% 
  t() %>% 
  as.data.frame() %>% 
  select(1:3, 5) 
colnames(df) <- c("Longitude","Latitude","Stop Name", "Stop Number")
rownames(df) <- NULL

df$Address <- mapply(function(lat, lon) {
  result <- revgeocode(as.numeric(c(lat, lon)))
  if (!is.null(result)) result else NA
}, df$Latitude, df$Longitude)

df$City = str_sub(str_extract(df$Address, ", .*, CA"), start=2, end=-5)

#df <- rename(df, "Address" = "address")

#AIzaSyAiP8QMVrPm8EnhAhBPRCx_9Erg6ENeHkA
#register_google(key="AIzaSyAiP8QMVrPm8EnhAhBPRCx_9Erg6ENeHkA")
