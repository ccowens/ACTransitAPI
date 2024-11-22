if(!require(curl)) {install.packages("curl"); library(curl)}
if(!require(jsonlite)) {install.packages("jsonlite"); library(jsonlite)}
if(!require(xml2)) {install.packages("xml2"); library(xml2)}
if(!require(dplyr)) {install.packages("dplyr"); library(dplyr)}
if(!require(XML)) {install.packages("XML"); library(XML)}

myToken <- "859CB1FE286DD9FA62741422C7C50162"
baseUrl <- "https://api.actransit.org/transit/"
  
myCommand <- "route/7/stops?direction=Southbound&"

myHandle <- new_handle()
handle_setheaders(myHandle, Accept = "application/xml")

response <- curl_fetch_memory(paste0(baseUrl,myCommand,"token=", myToken), myHandle)

xml_doc <- read_xml(response$content)
root_node <- xml_root(xml_doc)
xml_attrs(root_node) <- NULL

xml_to_dataframe <- function(xml_string) { 
  # Parse the XML string 
  xml_doc <- read_xml(xml_string) 
  # Extract all relevant nodes 
  nodes <- xml_find_all(xml_doc, "//RouteStopOrder.StopOrder") 
  # Convert nodes to a list of named vectors 
  data_list <- lapply(nodes, 
                      function(node) 
                        { children <- xml_children(node) 
                        sapply(children, xml_text) })
  # Convert list to a DataFrame 
  df <- bind_rows(lapply(data_list, as.data.frame))
}
x <- xmlParse(output)
saveXML(x,"x.xml")




xml_doc <- read_xml("x.xml", options="NOBLANKS")
xml_attrs(root_node) <- NULL
cat(as.character(xml_doc))




doc <- xmlParse(output)
root_node <- xmlRoot(doc) # Remove all attributes from the root node 
doc <- removeAttributes(root_node)
xmlToDataFrame(doc, nodes = getNodeSet(doc, "//Stops"))


output

y <-  read_xml(output)

xml_find_all(y, ".//Stops")

output <- '<ArrayOfRouteStopOrder xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://schemas.datacontract.org/2004/07/ACTransit.Transit.Domain.Models\">
<RouteStopOrder>
 <Destination>To Emeryville Amtrak</Destination>
 <Direction>Southbound</Direction>
 <Route>7</Route>
<Stops>
<RouteStopOrder.StopOrder>
 <Latitude>37.9242900</Latitude>
 <Longitude>-122.3163960</Longitude>
 <Name>Del Norte BART Bay 3</Name>
 <Order>1</Order>
 <StopId>52942</StopId>
 </RouteStopOrder.StopOrder>
<RouteStopOrder.StopOrder>
 <Latitude>37.9242900</Latitude>
 <Longitude>-122.3163960</Longitude>
 <Name>Del Norte BART Bay 3</Name>
 <Order>1</Order>
 <StopId>52942</StopId>
 </RouteStopOrder.StopOrder>
 </Stops>
 </RouteStopOrder>
 </ArrayOfRouteStopOrder>
'



write(output, "output.xml")
read_xml("output.xml")
