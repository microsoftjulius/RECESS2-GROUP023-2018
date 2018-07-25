#interpreting
output$ccc =renderPlot({
  clean <- data_cleaning()
  
  james<-read.csv(file = "C:/Users/Microsoft/Desktop/me2.csv", header = TRUE, stringsAsFactors = FALSE)
  ociba <-(james$Chat.content)
  s <- get_nrc_sentiment(ociba)
  head(s)
  
  #Barplot
  barplot(colSums(s),
          las=2,
          col = rainbow(10),
          ylab = "Count",
          main = "A barlot showing Emotions in NSSF Chat-content")
  
})

#emails per hour
output$mm <- renderPlot({
  
  #csv.file <- read.csv("E:/Recess2/Data_set_2_Chat_analysis/csv file.csv", header=FALSE)
  #str(csv.file)
  clean <- data_cleaning()
  upload_file() %>% select(Minutes) %>% mutate(Minutes = hms(Minutes)) %>% mutate(Minutes = hour(Minutes))%>%mutate(Minutes = as.factor(Minutes))%>%
    ggplot(aes(x= Minutes))+
    geom_bar()+
    labs(title="ggplot showing number of messages sent and recieved in a given hour",
         x="Time",
         y="Number of messages per hour")
  
})


#code for customer care perfomance
output$customerCare <- renderPlot({
  
  mydatasetcorpus <- Corpus(VectorSource(upload_file()$Operator))
  
  #Cleaning
  mydataset = gsub("[[:punct:]]", "", upload_file()$Operator)
  mydataset = gsub("[[:punct:]]", "", mydataset)
  mydataset = gsub("[[:digit:]]", "", mydataset)
  mydataset = gsub("http\\w+", "", mydataset)
  textdata = gsub("[ \t]{2,}", "", mydataset)
  mydataset = gsub("^\\s+|\\s+$", "", mydataset)
  
  
  dtm <- TermDocumentMatrix(mydatasetcorpus)
  termFrequency <- rowSums(as.matrix(dtm))
  termFrequency <- subset(termFrequency, termFrequency <=1200)
  barplot(termFrequency, col = rainbow(20), main = "Bar plot showing the perfomance of the different customercare operators", xlab = "Operators", ylab = "Perfomance")
  
  
  
})

#Countries barplot
output$participated <- renderPlot({
  
  #Cleaning
  mydataset = gsub("[[:punct:]]", "", upload_file()$Country)
  mydataset = gsub("[[:punct:]]", "", mydataset)
  mydataset = gsub("[[:digit:]]", "", mydataset)
  mydataset = gsub("http\\w+", "", mydataset)
  textdata = gsub("[ \t]{2,}", "", mydataset)
  mydataset = gsub("^\\s+|\\s+$", "", mydataset)
  
  mydatasetcorpus <- Corpus(VectorSource(upload_file$Country))
  dtm <- TermDocumentMatrix(mydatasetcorpus, control = list(removeNumbers = T, removePunctuation = T, stripWhitespace = T))
  termFrequency <- rowSums(as.matrix(dtm))
  barplot(termFrequency, las = 2, col = rainbow(20),main = "Bar plot showing participation of the different countries", xlab = "countries", ylab = "participation")
  
  
})


}

shinyApp(ui, server)