
library(tm)
library(tau)
library(igraph)


#convenience function(s)
dtm.top.terms <- function(dtm,n)
{
  m <- t(as.matrix(dtm))
  #  m <- t(as.simple_triplet_matrix(dtm))
  v <- sort(rowSums(m), decreasing=TRUE)
  head(v, n)
}


#plotting function
dtm.plot <- function(dtm, nterms=30, ncor=0, corThreshold=0, fontzoom=2, fontbump=0, ...)
{
  tw <- as.data.frame(dtm.top.terms(dtm,nterms))
  terms <- rownames(tw)
  m <- as.matrix(dtm[, terms])
  c <- cor(m)
  c[is.na(c)] <- 0
  diag(c) <- 0
  if(ncor==0 && corThreshold==0) ncor=nterms
  if(ncor>0) corThreshold <- sort(c(c),decreasing=TRUE)[ncor*2]
  c[c < corThreshold] <- 0
  
  ig <- graph.adjacency(c, weighted=TRUE, mode="lower")
  
  V(ig)$label.cex <- ((tw[,1] / max(tw[,1])) * fontzoom) + fontbump
  #     V(ig)$size <- tw[,1] * nchar(rownames(tw)) / 10
  #     V(ig)$size2 <- tw[,1]/3
  V(ig)$shape <- "none"
  E(ig)$width <- E(ig)$weight*10
  
  #lo <- layout.lgl(ig)
  #lo <- layout.graphopt(ig)
  #lo <- layout.auto(ig)
  plot(ig, ...)
}



###
### shiny stuff
###
library(shiny)

shinyServer(
  function(input, output) {
    output$the.image <- renderPlot({
      input$goButton
      isolate({
        ft <- input$fulltext
        corp <- strsplit(ft,"\n")[[1]]
        sw <- input$ignorewords
        sw <- strsplit(sw,"\n")[[1]]
        
        corp <- tolower(corp)
        corp <- removeWords(corp, sw)
        corp <- removePunctuation(corp)
        corp <- stripWhitespace(corp)
        
        dtm.ready <- DocumentTermMatrix(Corpus(VectorSource(corp)))
        dtm.plot(dtm.ready,input$terms,input$correls,asp=0.6,fontzoom=input$zoom)
        #plot(cars)
        })
      })
    
#     output$fulltext.textback <- renderPrint({
#       input$goButton
#       isolate({
#         ft <- input$fulltext
#         corp <- strsplit(ft,"\n")[[1]]
#         sw <- input$ignorewords
#         sw <- strsplit(sw,"\n")[[1]]
#         
#         corp <- tolower(corp)
#         corp <- removeWords(corp, sw)
#         corp <- removePunctuation(corp)
#         corp <- stripWhitespace(corp)
#       
#         corp
#         })
#       })
# 
#     output$ignorewords.textback <- renderPrint({
#       input$goButton
#       isolate({
#         ft <- input$ignorewords
#         st <- strsplit(ft,"\n")[[1]]
#         st      
#         })
#     })
    
  
})



