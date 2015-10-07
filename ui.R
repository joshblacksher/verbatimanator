
library(shiny)
library(tm)
esw <- paste(stopwords('english'), collapse="\n")

alice = 
"one per line
paste from excel works well

Alice was beginning to get very tired of sitting by her sister on the
bank, and of having nothing to do: once or twice she had peeped into the
book her sister was reading, but it had no pictures or conversations in
it, 'and what is the use of a book,' thought Alice 'without pictures or
conversations?'

So she was considering in her own mind (as well as she could, for the
hot day made her feel very sleepy and stupid), whether the pleasure
of making a daisy-chain would be worth the trouble of getting up and
picking the daisies, when suddenly a White Rabbit with pink eyes ran
close by her.

There was nothing so VERY remarkable in that; nor did Alice think it so
VERY much out of the way to hear the Rabbit say to itself, 'Oh dear!
Oh dear! I shall be late!' (when she thought it over afterwards, it
occurred to her that she ought to have wondered at this, but at the time
it all seemed quite natural); but when the Rabbit actually TOOK A WATCH
OUT OF ITS WAISTCOAT-POCKET, and looked at it, and then hurried on,
Alice started to her feet, for it flashed across her mind that she had
never before seen a rabbit with either a waistcoat-pocket, or a watch
to take out of it, and burning with curiosity, she ran across the field
after it, and fortunately was just in time to see it pop down a large
rabbit-hole under the hedge.
"

shinyUI(pageWithSidebar(

  headerPanel("Verbatim-anator v1"),

  sidebarPanel(
    h4("Documentation:"),
    p("Put the verbatim text in the first box.  
      Edit the ignore words in the second box.  
      Tune the number of words, lines, and font zoom to your liking.  Press Go!"),
    p("The size of the word is tied to it's frequency.  
      The thickness of the line is tied to the correlation between words."),
    
    h4("Verbatim text:"),
    tags$textarea(id="fulltext", rows=5, cols=40, alice),

    h4("Ignore words:"),
    tags$textarea(id="ignorewords", rows=5, cols=40, esw),  

    numericInput('terms', 'Words to show', 30, min = 0, max = 100, step = 1),
    numericInput('correls', 'Lines to show', 30, min = 0, max = 100, step = 1),
    numericInput('zoom', 'Font zoom', 5, min = 0, max = 100, step = 1),
    
    actionButton("goButton", "Go!")
  ),

  mainPanel(
    plotOutput('the.image', height=800, width=1000)
    
#     h4("fulltext"),
#     verbatimTextOutput("fulltext.textback"),
# 
#     h4("ignorewords"),
#     verbatimTextOutput("ignorewords.textback")
  )

))

