findParkrunUK <- function() {
        library(rvest)
        library(curl)
        library(RCurl)
        url <- "https://en.wikipedia.org/wiki/List_of_Parkruns_in_the_United_Kingdom"
        PRregions <- url %>%
                read_html() %>%
                html_nodes("ul") %>%
                html_text(trim = TRUE) %>%
                strsplit(split = "\n") %>%
                unlist()
        
        PRdf <- data.frame()
        PR <- list()
        for (i in 1:13) {
                webpage <- read_html(url)
                PR[i] <- webpage %>%
                        html_nodes(xpath = paste0('//*[@id="mw-content-text"]/div/table[', i, ']')) %>%
                        html_table(fill = TRUE)
                names(PR[[i]])<- names(PR[[1]])
                if (i==1) {PRdf <- PR[[1]]
                PRdf$Region <- PRregions[1]}
                else {PRdfinterm <- cbind(PR[[i]],Region=PRregions[i])
                PRdf <- rbind(PRdf,PRdfinterm)  }
                # PRdf$region <- PRregions[i]
        }
        baseurl <- "https://en.wikipedia.org/wiki/"
        lat <- vector(mode="character")
        long <- vector(mode="character")
        
        if (file.exists("latlong.Rdata")) {
                load("latlong.Rdata")
        } 
        else {
        for (j in 1:dim(PRdf)[1]) {
                townurl <- paste0(baseurl, gsub("^(.*?),.*", "\\1", PRdf[j,2]))
                townurl <- gsub(" ", "_", townurl)
                if (url.exists(townurl)) {
                lattemp <- read_html(curl(townurl),handle = curl::new_handle("useragent" = "Mozilla/5.0")) %>%
                        html_nodes(".latitude")%>%
                        html_text(trim = TRUE) %>%
                        strsplit(split = "\n")
                longtemp <- read_html(curl(townurl),handle = curl::new_handle("useragent" = "Mozilla/5.0")) %>%
                        html_nodes(".longitude")%>%
                        html_text(trim = TRUE) %>%
                        strsplit(split = "\n")
                if (length(lattemp)>0) {lat[j] <- lattemp[[1]]} else {lat[j] <- ""}
                if (length(longtemp)>0) {long[j] <- longtemp[[1]]} else {long[j] <- ""}
                }
                else {
                lat[j] <- ""
                long[j] <- ""
                }
                        }
                save(lat,long,file="latlong.Rdata")
        }
        
        PRdf$Region <- substring(PRdf$Region,regexpr("[A-Z]",PRdf$Region))
        PRdf$Lat <- lat
        PRdf$Long <- long
        PRdf$Name <- gsub("[[0-9](.*?)]","",as.character(PRdf$Name))
        PRdf
}

