library(shiny)
library(ggplot2)
library(dplyr)
library(cowplot)

predictions <- readRDS('../data/predictions.rds')
ratings <- read.csv('../data/WGU-Ratings.csv')
daacs_essays <- readRDS("../data/DAACS_Essays.rds")

predictions$prediction_int <- predictions$prediction |> round() |> as.integer()
predictions <- predictions |>
    dplyr::filter(model != 'LinearRegression') |>
    dplyr::filter(domain != 'TotalScore')
predictions$prediction_int |> is.na() |> table()
ratings[!ratings$Corated,30:39] <- ratings[!ratings$Corated,5:14]
ratings_melted <- ratings[,c(2,30:38)] |> reshape2::melt(id.vars = 'EssayID', value.name = 'ActualScore')
predictions <- merge(predictions, ratings_melted,
                     by.x = c('daacs_id', 'domain'),
                     by.y = c('EssayID', 'variable'),
                     all.x = TRUE)
predictions$ActualScore <- predictions$ActualScore - 1
predictions$Accurate <- predictions$ActualScore == predictions$prediction_int
predictions <- predictions |>
    dplyr::filter(domain != 'Corated')


##### UI #######################################################################
ui <- fluidPage(
    titlePanel("DAACS Automated Scoring"),

    sidebarLayout(
        sidebarPanel(
            width = 3,
            uiOutput('domain_ui')
        ),

        mainPanel(
            width = 9,
            plotOutput('domain_plot')
        )
    )
)

##### Server ###################################################################
server <- function(input, output) {
    output$domain_ui <- renderUI({
        selectInput('domain', label = 'Domain', choices = unique(predictions$domain))
    })

    output$overall_plot <- renderPlot({
        tab <- predictions |>
            dplyr::group_by(domain, tokenizer, model) |>
            dplyr::summarise(Accuracy = mean(Accurate, na.rm = TRUE))


        p1 <- ggplot(tab, aes(x = Accuracy, y = model, color = tokenizer)) +
            geom_point() +
            facet_grid(~ domain) +
            ylab('') +
            # theme_minimal() +
            theme(legend.position = 'bottom') +
            guides(color = guide_legend(nrow=1,byrow=TRUE))

        p2 <- ggplot(tab, aes(x = Accuracy, y = tokenizer, color = model)) +
            geom_point() +
            facet_grid(~ domain) +
            ylab('') +
            # theme_minimal() +
            theme(legend.position = 'bottom') +
            guides(color = guide_legend(nrow=1,byrow=TRUE))

        cowplot::plot_grid(p1, p2, ncol = 1)
    })

    output$domain_plot <- renderPlot({
        tab <- predictions |>
            dplyr::filter(domain == input$domain) |>
            dplyr::group_by(tokenizer, model) |>
            dplyr::summarise(Accuracy = mean(Accurate, na.rm = TRUE))

        p1 <- ggplot(tab, aes(x = Accuracy, y = model, color = tokenizer)) +
            geom_point() +
            ylab('') +
            theme(legend.position = 'bottom') +
            guides(color = guide_legend()) +
            ggtitle(paste0(input$domain))

        p2 <- ggplot(tab, aes(x = Accuracy, y = tokenizer, color = model)) +
            geom_point() +
            ylab('') +
            theme(legend.position = 'bottom') +
            guides(color = guide_legend()) +
            ggtitle(paste0(input$domain))

        cowplot::plot_grid(p1, p2, nrow = 1)
    })
}

##### Run the application ######################################################
shinyApp(ui = ui, server = server)
