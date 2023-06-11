library(shiny)
shinyServer(function(input, output) {
    iris$lengthsp <- ifelse(iris$Sepal.Length - 5 > 0, iris$Sepal.Length - 5, 0)
    model1 <- lm(Petal.Length ~ Sepal.Length, data = iris)
    model2 <- lm(Petal.Length ~ lengthsp + Sepal.Length, data = iris)
    
    model1pred <- reactive({
        Sepal.LengthInput <- input$sliderSepal.Length
        predict(model1, newdata = data.frame(Sepal.Length = Sepal.LengthInput))
    })
    
    model2pred <- reactive({
        Sepal.LengthInput <- input$sliderSepal.Length
        predict(model2, newdata = 
                    data.frame(Sepal.Length = Sepal.LengthInput,
                               lengthsp = ifelse(Sepal.LengthInput - 5 > 0,
                                                 Sepal.LengthInput - 5, 0)))
    })
    
    output$plot1 <- renderPlot({
        Sepal.LengthInput <- input$sliderSepal.Length
        
        plot(iris$Sepal.Length, iris$Petal.Length, xlab = "Sepal Length", 
             ylab = "Petal Width", bty = "n", pch = 16,
             xlim = c(3, 7), ylim = c(0, 7))
        if(input$showModel1){
            abline(model1, col = "red", lwd = 2)
        }
        if(input$showModel2){
            model2lines <- predict(model2, newdata = data.frame(
                Sepal.Length = 0:7, lengthsp = ifelse(0:7 - 5 > 0, 0:7 - 5, 0)
            ))
            lines(0:7, model2lines, col = "blue", lwd = 2)
        }
        legend(25, 20, c("Model 1 Prediction", "Model 2 Prediction"), pch = 16, 
               col = c("red", "blue"), bty = "n", cex = 1.2)
        points(Sepal.LengthInput, model1pred(), col = "red", pch = 16, cex = 2)
        points(Sepal.LengthInput, model2pred(), col = "blue", pch = 16, cex = 2)
    })
    
    output$pred1 <- renderText({
        model1pred()
    })
    
    output$pred2 <- renderText({
        model2pred()
    })
})    