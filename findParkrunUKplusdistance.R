findParkrunUKplusdistance <- function(postcode) {
        library(rvest)
        library(curl)
        library(RCurl)
        library(measurements)
        library(stringr)
        library(geosphere)
        library(xml2)
        library(bitops)
        
        if (postcode=="") 
        {
                stop("Please enter a postcode")
        }
        else if (length(grep(" ",postcode))==0)
        {
                postcode <- paste(str_sub(postcode,-nchar(postcode),-4),str_sub(postcode,-3,-1))
        }
        
        postcode <- str_to_upper(postcode)
         dist <- vector(mode="numeric")
        
        postcodes <- read.csv("ukpostcodes.csv")
        latinput <- postcodes[which(postcodes[,2]==postcode),3]
        longinput <- postcodes[which(postcodes[,2]==postcode),4]
        
        if (file.exists("PRdf.csv")) {
                # appfile <- read.csv("latlongdist.csv")
                appfile <- read.csv("PRdf.csv")
                matrix2 <- matrix(c(as.numeric(appfile$Longnum), as.numeric(appfile$Latnum)),nrow=dim(appfile)[1],ncol=2)
                # latnum <- appfile$Latnum
                # longnum <- appfile$Longnum
                dist <- distm(matrix2,c(longinput,latinput), fun = distHaversine)
                dist <- as.numeric(dist)/1609
                appfile <- cbind(appfile[,-c(1,c(7:9))],dist)
                names(appfile)[6] <- paste("Distance in miles")
                appfile
        }        
        else {
                
                url <- "https://en.wikipedia.org/wiki/List_of_Parkruns_in_the_United_Kingdom"
                download.file(url, destfile = "scrapedpage.html", quiet=TRUE)
                PRregions <- read_html("scrapedpage.html") %>%
                        html_nodes("ul") %>%
                        html_text(trim = TRUE) %>%
                        strsplit(split = "\n") %>%
                        unlist()
                
                PRdf <- data.frame()
                PR <- list()
                PRtitles <- list()
                PRurls <- list()
                PRurlsfiltered <- vector(mode="character")
                for (i in 1:13) {
                        webpage <- read_html("scrapedpage.html")
                        PR[[i]] <- webpage %>%
                                html_nodes("table") %>% 
                                html_table(fill = TRUE) %>%
                                .[[i]]
                        PRtitles[[i]] <- webpage %>%
                                html_nodes("table") %>% .[[i]] %>% html_nodes("a") %>% html_text()
                        PRurls[[i]] <- webpage %>%
                                html_nodes("table") %>% .[[i]] %>% html_nodes("a") %>% html_attr("href") 
                        
                        
                        for (k in 1:dim(PR[[i]])[1])
                        {
                                if (length(pmatch(str_split(PR[[i]][k,2],",")[[1]][1],PRtitles[[i]]))!=0 & is.na(pmatch(str_split(PR[[i]][k,2],",")[[1]][1],PRtitles[[i]]))==FALSE) 
                                {
                                        PRurlsfiltered <-  rbind(PRurlsfiltered,PRurls[[i]][pmatch(str_split(PR[[i]][k,2],",")[[1]][1],PRtitles[[i]])][1])        
                                }
                                else
                                {
                                        PRurlsfiltered <-  rbind(PRurlsfiltered,PRurls[[i]][pmatch(PR[[i]][k,2],PRtitles[[i]])][1])
                                }
                        }                
                        
                        names(PR[[i]])<- names(PR[[1]])
                        if (i==1) {PRdf <- PR[[1]]
                        PRdf$Region <- PRregions[1]
                        }
                        else {PRdfinterm <- cbind(PR[[i]],Region=PRregions[i])
                        PRdf <- rbind(PRdf,PRdfinterm)  }
                }
                
                PRdf <- cbind(PRdf,URL=PRurlsfiltered)
                baseurl <- "https://en.wikipedia.org"
                latnum <- vector(mode="character")
                longnum <- vector(mode="character")
                town <- vector(mode="character")
                
                for (j in 1:dim(PRdf)[1]) {
                        # townurl <- paste0(baseurl, gsub("^(.*?),.*", "\\1", PRdf[j,2]))
                        # townurl <- gsub(" ", "_", townurl)
                        townurl <- paste0(baseurl, PRdf[j,6])
                        town[j] <- townurl
                        lattemp <- ""
                        longtemp <- ""
                        if (url.exists(townurl)) 
                        {
                                lattemp <- read_html(curl(townurl),handle = curl::new_handle("useragent" = "Mozilla/5.0")) %>%
                                        html_nodes(".latitude")%>%
                                        html_text(trim = TRUE) %>%
                                        strsplit(split = "\n")
                                longtemp <- read_html(curl(townurl),handle = curl::new_handle("useragent" = "Mozilla/5.0")) %>%
                                        html_nodes(".longitude")%>%
                                        html_text(trim = TRUE) %>%
                                        strsplit(split = "\n")
                                
                                if (length(lattemp)>0) 
                                {
                                        latrep <- str_replace_all(lattemp, "[^[:alnum:]]", " ")
                                        latsplit <- strsplit(latrep," ")
                                        if (is.na(latsplit[[1]][4])==FALSE) 
                                        {
                                                latnum[j] <- as.numeric(latsplit[[1]][1])+ as.numeric(latsplit[[1]][2])/60 + as.numeric(latsplit[[1]][3])/3600
                                        }
                                        else if (length(grep("\\.",lattemp))==0) 
                                        {
                                                latnum[j] <- as.numeric(latsplit[[1]][1]) + as.numeric(latsplit[[1]][2])/60
                                        }
                                        else
                                        {
                                                latnum[j] <- as.numeric(paste(latsplit[[1]][1],".",latsplit[[1]][2],sep=""))
                                        }
                                        
                                }
                                else 
                                {
                                        latnum[j] <- ""
                                }
                                if (length(longtemp)>0) 
                                {
                                        longrep <- str_replace_all(longtemp, "[^[:alnum:]]", " ")
                                        longsplit <- strsplit(longrep," ")
                                        if (is.na(longsplit[[1]][4])==FALSE & longsplit[[1]][4]=="E") 
                                        {
                                                longnum[j] <- as.numeric(longsplit[[1]][1])+ as.numeric(longsplit[[1]][2])/60 + as.numeric(longsplit[[1]][3])/3600
                                        }
                                        else if (is.na(longsplit[[1]][4])==FALSE & longsplit[[1]][4]=="W") 
                                        {
                                                longnum[j] <- -as.numeric(longsplit[[1]][1])- as.numeric(longsplit[[1]][2])/60 - as.numeric(longsplit[[1]][3])/3600
                                        }
                                        else if (is.na(longsplit[[1]][4])==TRUE & longsplit[[1]][3]=="E")
                                        { 
                                                if (length(grep("\\.",longtemp))==0) 
                                                {
                                                longnum[j] <- as.numeric(longsplit[[1]][1]) + as.numeric(longsplit[[1]][2])/60
                                                }
                                                else
                                                {
                                                longnum[j] <- as.numeric(paste(longsplit[[1]][1],".",longsplit[[1]][2],sep=""))
                                                }
                                        }
                                        else 
                                        {
                                                if (length(grep("\\.",longtemp))==0) 
                                                {
                                                longnum[j] <- -as.numeric(longsplit[[1]][1]) - as.numeric(longsplit[[1]][2])/60
                                                }
                                                else
                                                {
                                                longnum[j] <- -as.numeric(paste(longsplit[[1]][1],".",longsplit[[1]][2],sep=""))     
                                                }
                                        }
                                }
                                else 
                                {
                                        longnum[j] <- ""
                                }
                        }
                        else 
                        {
                                latnum[j] <- ""
                                longnum[j] <- ""
                        }
                }
                # write.csv(cbind(latnum,longnum,town),"latlongdist.csv")
                PRdf$Region <- substring(PRdf$Region,regexpr("[A-Z]",PRdf$Region))
                PRdf$Latnum <- latnum
                PRdf$Longnum <- longnum
                # PRdf$Distance <- as.numeric(dist)/1000
                # names(PRdf)[7] <- paste(names(PRdf)[7]," in miles")
                PRdf$Name <- gsub("[[0-9](.*?)]","",as.character(PRdf$Name))
                write.csv(PRdf,"PRdf.csv")
        }
        

}

