####links


##how many pages to go back
num_of_ads = read_html("https://turbo.az/") %>% html_elements("div.main-search__footer-left") %>% html_text()
num_of_ads = as.numeric(gsub("\\D", "", num_of_ads))

num_of_pages = round(num_of_ads/24)
hrefs = c(0)

##

#link = read_html("https://turbo.az/autos?page=1")

#hrefs = link %>% html_elements("a.products-i__link") %>%  html_attr("href")
#hrefs = hrefs[13:36]



for (u in 1:num_of_pages) {
  
  link = read_html(paste0("https://turbo.az/autos?page=", u))
  hrefs = link %>% html_elements("a.products-i__link") %>%  html_attr("href")
  hrefs = hrefs[13:36]
  
    for (i in 1:length(hrefs)) {
    link_car = paste0("https://turbo.az", hrefs[i])
    Sys.sleep(runif(1, min=0.5, max=1.5))
    data1 <- rbind(data1, scrape_turbo_az(link_car), fill=TRUE)
 
    }
 if(u %% 6==0) { Sys.sleep(3) }

}
