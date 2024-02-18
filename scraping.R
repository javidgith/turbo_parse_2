##turbo.az - page scraping
library(rvest) #install rvest
library(data.table)
library(dplyr)
library(stringi)

data1 = data.table(ItemID=integer(), Property = character(), Value=character(), stringsAsFactors = FALSE)


scrape_turbo_az = function(url) {
  
  
  
 page = read_html(url) #crawl page
 
 
 ##extract data
 properties_name = page %>% html_elements("div.product-properties__i") %>% html_children() %>% html_text()
 ItemID = page %>% html_elements("div.product-actions__id") %>% html_text()
 price = page %>% html_elements("div.product-price__i--bold") %>% html_text()
 if(grepl("USD", price)) { 
   price = page %>% html_elements("div.tz-mt-10") %>% html_text()
  }
 date = page %>% html_elements("span.product-statistics__i-text") %>% html_text()


 ##text manipulation
 ItemID = as.numeric(gsub("\\D", "", ItemID))
 price = as.numeric(gsub("\\D", "", price))
 properties_name = stri_trans_general(properties_name, "Latin-ASCII")
 properties_name = gsub("ə", "e", properties_name)
 date[1] = stri_extract_last_words(date[1])
 

 ##data manipulation
 p1 = properties_name[seq(1, length(properties_name), 2)]
 p2 = properties_name[seq(2, length(properties_name), 2)]
 p1 = c(p1, "Qiymet", "Tarix")

 p2 = c(p2, price, date[1])

 scraped_data <- data.table(Property = p1, Value = p2, ItemID = ItemID)

return(scraped_data)

}




data2 = dcast(data1, ItemID ~ Property, value.var = "Value", fun.aggregate = first) #transpose ready


