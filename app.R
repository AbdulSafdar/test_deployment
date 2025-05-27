# app.R
library(shiny)
library(tidyverse)
library(here)

# Create dummy data and save it if not already there
data_dir <- here("data")
if (!dir.exists(data_dir)) dir.create(data_dir)

csv_path <- here("data", "dummy_data.csv")

if (!file.exists(csv_path)) {
  dummy_df <- tibble(
    ID = 1:100,
    Name = paste("Person", 1:100),
    Age = sample(18:80, 100, replace = TRUE),
    Score = round(runif(100, 50, 100), 1)
  )
  write_csv(dummy_df, csv_path)
}

# Read the data
dummy_data <- read_csv(csv_path, show_col_types = FALSE)

# UI
ui <- fluidPage(
  titlePanel("Dummy Secure Data App"),
  sidebarLayout(
    sidebarPanel(
      helpText("This app loads a local CSV file stored securely in the server.")
    ),
    mainPanel(
      h4("Summary Statistics"),
      verbatimTextOutput("summary"),
      h4("Sample of Data"),
      tableOutput("table")
    )
  )
)

# Server
server <- function(input, output, session) {
  output$summary <- renderPrint({
    summary(dummy_data)
  })
  
  output$table <- renderTable({
    head(dummy_data, 10)
  })
}

shinyApp(ui, server)
