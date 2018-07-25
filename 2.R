server <- function(input, output, session) {
  
  
  #displaying table
  output$table.output <- renderTable(striped = TRUE, hover = TRUE, bordered = TRUE,width = 50, spacing = 's',
                                     {
                                       upload_file()
                                       
                                     })
  #uploading file
  upload_file <- reactive({
    inFile <- input$file1
    
    if (is.null(inFile))
      
      return(NULL)
    
    tbl <- read.csv(inFile$datapath, header = input$header,sep = input$sep,dec = input$dec,
                    strip.white = TRUE, blank.lines.skip = TRUE, stringsAsFactors = FALSE)
    
    return(tbl)
  })
  
  data_cleaning <- reactive({
    
    ociba <- upload_file()
    ociba1 <- ociba[, "Chat.content"]
    
    corpus <-Corpus(VectorSource(ociba1))
    corpus <- tm_map(corpus,removeNumbers)
    corpus <- tm_map(corpus,removePunctuation)
    corpus <- tm_map(corpus,stripWhitespace)
    corpus <- tm_map(corpus,tolower)
    corpus <- tm_map(corpus,stemDocument)
    clean <- tm_map(corpus, removeWords,stopwords('english'))
    clean <-tm_map(corpus, removeWords,c("customerservicenssfugorg","the","for","your","you","akurut","chat","system","nssf","have","has","that","can","while","and","are","but","will","with"))
  })
  
  
  
  output$wc =renderPlot({
    clean <- data_cleaning()
    wordcloud(clean,random.order = FALSE,colors = brewer.pal(6,"Dark2"),scale = c(5,0.3),max.words = 100, min.freq = 50)
    title(main = "Wordcloud showing the Most appearing Words and Names in the Chat-content")
  })
  
  output$suma <- renderPlot({
    clean <- upload_file()
    ociba1 <- clean$Chat.content
    
    moses_clean <- sentiment_by(ociba1)
    
    clean$sentiment <- moses_clean$ave_sentiment
    
    
    positive_chats <- head(clean[order(moses_clean$ave_sentiment,
                                       decreasing = T),],25)
    
    positive_charts <- head(unique(clean[order(moses_clean$ave_sentiment,
                                               decreasing = T),]),25)
    
    write.table(positive_charts$Chat.content,file ="C:/Users/Microsoft/Desktop/emails/positve.csv", sep = "" )
    
    negative_charts <- head(unique(clean[order(moses_clean$ave_sentiment,
                                               decreasing = F),]),25)
    
    write.table(negative_charts$Chat.content,file ="C:/Users/Microsoft/Desktop/emails/negative.csv", sep ="")
    
    pos_neg_charts <- c(positive_charts,negative_charts)
    
    clean_corpus <- Corpus(DirSource(directory = "C:/Users/Microsoft/Desktop/emails"))
    
    c_clean_corpus <- tm_map(clean_corpus, tolower)
    c_clean_corpus <- tm_map(c_clean_corpus, removePunctuation)
    my_stopwords <- c(stopwords(),"akurut", "diana", "akoli","justus","simon","ebulu","david","system","chat","tumwesigy","nambuva","customerservicenssfugorg","nssf","sandra")
    c_clean_corpus <- tm_map(c_clean_corpus,removeWords,my_stopwords)
    c_clean_corpus <- tm_map(c_clean_corpus,stripWhitespace)
    c_clean_corpus <- tm_map(c_clean_corpus,stemDocument)
    c_clean_corpus <- tm_map(c_clean_corpus, removeNumbers)
    
    ctc_tdm <- TermDocumentMatrix(c_clean_corpus)
    
    ctc_matrix <- as.matrix(ctc_tdm)
    
    colnames(ctc_matrix) <- c("Negative chats","Positive chats")
    
    comparison.cloud(ctc_matrix, colors = brewer.pal(3,"Dark2"),max.words = 100, 
                     random.order = F, scale=c(4,.5))
    title(main = "Word cloud showing both negative and positive reactions")
    
  })
  
  
  output$barplot =renderPlot({
    clean <- data_cleaning()
    
    dtm <-TermDocumentMatrix(clean,control=list(minwordLength=c(1,Inf)))
    findFreqTerms(dtm,lowfreq=20)
    #barplot
    termFrequency <-rowSums(as.matrix(dtm))
    termFrequency <-subset(termFrequency,termFrequency>=10)
    termFrequency[1:50]
    library(ggplot2)
    barplot(termFrequency[120:150],las=2,col = rainbow(20),
            ylab = "Frequency")
    title(main = "A barplot showing Most used Words in NSSF Emails")
  })