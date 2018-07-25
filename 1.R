library(shiny)
library(shinydashboard)
library(tm)
library(stringr)
library(wordcloud)
library(RColorBrewer)
library(SnowballC)
library(plyr)
library(ggplot2)
library(plotly)
library(tidyverse)
library(tidyr)
library(dplyr)
library(reshape2)
library(syuzhet)
library(sentimentr)
library(lubridate)
library(scales)
library(anytime)
library(shinythemes)
library(XML)



ui <- dashboardPage(
  
  dashboardHeader(title = "WELCOME TO NSSF"),
  skin = "yellow",
  dashboardSidebar("GROUP 23",
                   subtitle =a(href="#", icon("circle", class = "text-success"), "online"),
                   sidebarSearchForm(label = "Enter a number","searchText","searchButton"),
                   sidebarMenu(
                     id="tabs",
                     menuItem("Data to be Analysed", tabName = "analysed", icon = icon("th"),badgeLabel = "new", badgeColor = "green"),
                     menuItem("Visualized data", tabName = "visualized", icon = icon("file-code-o")),
                     menuItem("Predicted data", tabName = "predicted", icon = icon("life-ring"))
                   )
  ),
  
  dashboardBody(
    tags$head(
      tags$link(tags$style(HTML('
                                .main-header .logo {
                                font-family:"georgia",Times, "Times New Roman", serif;
                                background-color: #3c8dbc;;
                                } 
                                /* background color of the header (logo part) */
                                .skin-blue .main-header .logo:hover {
                                background-color: #3c8dbc;
                                }
                                ')))
      
      ),
    #tags$style("body{background-color:yellow;color:green}"),
    
    tags$script('
                // Bind function to the toggle sidebar button
                $(".sidebar-toggle").on("click",function(){
                // Send value to Shiny 
                Shiny.onInputChange("toggleClicked", Math.random() );
                })'
    ),
    tabItems(
      
      tabItem("visualized",div(h2(p("Visualized tab content"))
                               
                               
      ),
      mainPanel(
        tabsetPanel(
          tabPanel("Wordcloud",plotOutput("wc")),
          tabPanel("Summarized",plotOutput("suma")),
          tabPanel("Bargraph",plotOutput("barplot")),
          tabPanel("Scores",plotOutput("ccc")),
          tabPanel("Emails",plotOutput("mm")),
          tabPanel("Performance",plotOutput("customerCare")),
          tabPanel("Countries",plotOutput("participated"))
          
        ))
      ),
      tabItem("predicted",div(h2(p("SUMMARY ON VISUALIZATION"))),
              div(p("According to the results  from visualization, we see that Diana Akurut is the most Active Worker")),
              div(p("attend,hold,close,welcome,query,accept,assist,live are words customer operators could use when 
                    replying their customers")),
              div(p("The analysis shows that the number of people contacting Nssf trust them so much than the number of people commenting negatively")),
              div(p("The most Occuring Problems the customers are getting are Issues with there Passwords")),
              div(h2("PREDICTION")),
              div(p("From the plot showing number of Emails versus time of recieving the Emails, we predict that more workers should be employeed between 9:30am to 4:30pm")),
              div(p("More workers should be employeed to work with Diana Akurut in order to reduce the waiting time of the customers")),
              div(h2("Conclusion")),
              div(p("Since many people are commenting during the working hours, and since Diana is the most working person during these hours, we Conclude that More Workers Should be employeed to work  between 9:30am and 4:30pm")),
              div(p(""))),
      tabItem("analysed",div(h2(p("These are the files uploaded to R"))),
              pageWithSidebar(
                headerPanel('CLICK BROWSE TO UPLOAD YOUR FILE'),
                sidebarPanel(
                  fileInput('file1', 'Choose CSV File',
                            accept=c('text/csv', 'text/comma-separated-values', 'text/plain', '.csv')),
                  tags$hr(),
                  checkboxInput('header', 'Header', TRUE),
                  radioButtons('sep', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'))
                  
                ),
                mainPanel(
                  tableOutput(outputId = 'table.output'),
                  plotOutput("plot2")
                ))
              
      )
              )
    )
      )