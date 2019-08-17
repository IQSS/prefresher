# Visualization

library(dplyr)
library(readr)
library(ggplot2)
library(forcats)
library(scales)



### Where are we? Where are we headed? {-}

# Up till now, you should have covered:
#   
# * The R Visualization and Programming primers at  <https://rstudio.cloud/primers/>
# * Reading and handling data
# * Matrices and Vectors
# * What does `:` mean in R? What about `==`? `,`?, `!=` , `&`, `|`, `%in% `
# * What does `%>%` do?
#   
#   
# Today we'll cover:
# 
# * Visualization
# * A bit of data wrangling

### Check your understanding

# * How do you make a barplot, in base-R and in ggplot?
# * How do you add layers to a ggplot?
# * How do you change the axes of a ggplot? 
# * How do you make a histogram? 
# * How do you make a graph that looks like this?
# 


## Motivation: The Law of the Census

# In this module, let's visualize some cross-sectional stats with an actual Census. Then, we'll 
# do an example on time trends with Supreme Court ideal points. 


## Read data

# First, the census. Read in a subset of the 2010 Census that we looked at earlier. This time, it is in Rds form.

cen10 <- readRDS("data/input/usc2010_001percent.Rds")

## Counting
# How many people are in your sample?

nrow(cen10)



# This and all subsequent  tasks involve manipulating and summarizing data, sometimes called "wrangling".
# As per last time, there are both "base-R" and "tidyverse" approaches. 

# We have already seen several functions from the tidyverse:
# 
# * `select` selects columns
# * `filter` selects rows based on a logical (boolean) statement
# * `slice` selects rows based on the row number
# * `arrange` reordered the rows in descending order.

# In this visualization section, we'll make use of the pair of functions `group_by()` and `summarize()`. 


## Tabulating

# Summarizing data is the key part of communication; good data viz gets the point across.
# Summaries of data come in two forms: tables and figures.

# Here are two ways to count by group, or to tabulate.

# In base-R Use the `table` function, that provides how many rows exist for an unique value of the vector 
# (remember `unique`?)

table(cen10$race)



# With tidyverse, a quick convenience function is `count`, with the variable to count on included.

count(cen10, race)


# We can check out the arguments of `count` and see that there is a `sort` option. What does this do?

count(cen10, race, sort = TRUE)


# `count` is a kind of shorthand for `group_by()` and `summarize`. This code would have done the same. 

cen10 %>% 
  group_by(race) %>% 
  summarize(n = n())


# If you are new to tidyverse, what would you _think_ each row did? Reading the function help page, 
# verify if your intuition was correct. 

## base R graphics and ggplot

# Two prevalent ways of making graphing are referred to as "base-R" and "ggplot".


### base R

# "Base-R"  graphics are graphics that are made with R's default graphics commands. 
# First, let's assign our tabulation to an object, then put it in the `barplot()` function.

barplot(table(cen10$race))


### ggplot
# A popular alternative a `ggplot` graphics, that you were introduced to in the tutorial. `gg` stands 
# for grammar of graphics by Hadley Wickham, and it has a new semantics of explaining graphics in R. 
# Again, first let's set up the data. 

# Although the tutorial covered making scatter plots as the first cut, often data requires summaries 
# before they made into graphs.

# For this example, let's group and count first like we just did. But assign it to a new object.

grp_race <- count(cen10, race)


# We will now plot this grouped set of numbers. Recall that the `ggplot()` function takes two 
# main arguments, `data` and `aes`. 

# 1. First enter a single dataframe from which you will draw a plot.
# 2. Then enter the `aes`, or aesthetics. This defines which variable in the data the plotting functions 
# should take for pre-set dimensions in graphics. The dimensions `x` and `y` are the most important. 
# We will assign `race` and `count` to them, respectively,
# 3. After you close `ggplot()` .. add layers by the plus sign. A `geom` is a layer of graphical 
# representation, for example `geom_histogram` renders a histogram, `geom_point` renders a scatter plot. 
# For a barplot, we can use `geom_col()`



# What is the right geometry layer to make a barplot? Turns out: 
  
ggplot(data = grp_race, aes(x = race, y = n)) + geom_col()



## Improving your graphics

# Adjusting your graphics to make the point clear is an important skill. Here is a base-R 
# example of showing the same numbers but with a different design, in a way that aims to 
# maximize the "data-to-ink ratio".

par(oma = c(1, 11, 1, 1))
barplot(sort(table(cen10$race)), # sort numbers
        horiz = TRUE, # flip
        border = NA, # border is extraneous
        xlab = "Number in Race Category", 
        bty = "n", # no box
        las = 1) # alignment of axis labels is horizontal


# Notice that we applied the `sort()` function to order the bars in terms of their counts. 
# The default ordering of a categorical variable / factor is alphabetical. Alphabetical ordering 
# is uninformative and almost never the way you should order variables.

# In ggplot you might do this by:
library(forcats)

grp_race_ordered <- arrange(grp_race, n) %>% 
  mutate(race = as_factor(race))

ggplot(data = grp_race_ordered, aes(x = race, y = n)) +
  geom_col() +
  coord_flip() +
  labs(y = "Number in Race Category",
       x = "",
       caption = "Source: 2010 U.S. Census sample")


## Cross-tabs

# Visualizations and Tables each have their strengths. A rule of thumb is that more than a dozen 
# numbers on a table is too much to digest, but less than a dozen is too few for a figure to be worth it. 
# Let's look at a table first. 

# A cross-tab is counting with two types of variables, and is a simple and powerful tool to show the 
# relationship between multiple variables.

xtab_race_state <- table(cen10$state, cen10$race)
xtab_race_state


# Another function to make a cross-tab is the `xtabs` command, which uses formula notation.
xtabs(~ state + race, cen10)



# What if we care about proportions within states, rather than counts? 
# Say we'd like to compare the racial composition of a small state (like Delaware) 
# and a large state (like California). In fact, most tasks of inference is about the 
# unobserved population, not the observed data --- and proportions are estimates of a 
# quantity in the population.

# One way to transform a table of counts to a table of proportions is the function `prop.table`. 
# Be careful what you want to take proportions of -- this is set by the `margin` argument. 
# In R, the first margin (`margin = 1`) is _rows_ and the second (`margin = 2`) is _columns_.

ptab_race_state <- prop.table(xtab_race_state, margin = 2)
ptab_race_state

# Check out each of these table objects in your console and familiarize yourself with the difference.



## Composition Plots

# How would you make the same figure with `ggplot()`? First, we want a count for each state * race combination. 
# So group by those two factors and count how many observations are in each two-way categorization. 
# `group_by()` can take any number of variables, separated by commas. 


grp_race_state <- cen10 %>% 
  count(race, state)


# Can you tell from the code what `grp_race_state` will look like?
  
grp_race_state


# Now, we want to tell `ggplot2` something like the following: I want bars by state, 
# where heights indicate racial groups. Each bar should be colored by the race. With 
# some googling, you will get something like this:
  
ggplot(data = grp_race_state, aes(x =  state, y = n,  fill = race)) +
  geom_col(position = "fill") + # the position is determined by the fill ae
  scale_fill_brewer(name = "Census Race", palette = "Spectral", direction = -1) + # choose palette
  coord_flip() + # flip axes
  scale_y_continuous(labels = percent) + # label numbers as percentage
  labs(y = "Proportion of Racial Group within State",
       x = "",
       source = "Source: 2010 Census  sample") +
  theme_minimal()



## Line graphs

# Line graphs are useful for plotting time trends.  

# The Census does not track individuals over time. So let's take up another example: 
# The U.S. Supreme Court. Take the dataset `justices_court-median.csv`.

# This data is adapted from the estimates of Martin and Quinn on their website 
# <http://mqscores.lsa.umich.edu/>.^[This exercise inspired from Princeton's R Camp Assignment.]  


justice <- read_csv("data/input/justices_court-median.csv")

# What does the data look like? How do you think it is organized? What does each row represent?
  
justice


# As you might have guessed, these data can be shown in a time trend from the range of the `term`
# variable. As there are only nine justices at any given time and justices have life tenure, there 
# times on the court are staggered. With a common measure of "preference", we can plot time trends 
# of these justices ideal points on the same y-axis scale. 

ggplot(justice, aes(x = term, y = idealpt)) +
  geom_line()

# Why does the above graph not look like the the plot in the beginning? Fix it by adding just one aesthetic to the graph.
# enter a correction that draws separate lines by group.


# If you got the right aesthetic, this seems to "work" off the shelf. But take a moment to see why the code was 
# written as it is and how that maps on to the graphics. What is the `group` aesthetic doing for you? 
  
# Now, this graphic already indicates a lot, but let's improve the graphics so people can actually read it.  
# This is left for a Exercise. 



# As social scientists, we should also not forget to ask ourselves whether these numerical measures are fit 
# for what we care about, or actually succeeds in measuring what we'd like to measure. The estimation of 
# these "ideal points" is a subfield of political methodology beyond this prefresher. For more reading, 
# see citations in the prefresher booklet.



## Exercises
# In the time remaining, try the following exercises. Order doesn't matter. 

### 1: Rural states

# Make a well-labelled figure that plots the proportion of the state's population (as per the census) 
# that is 65 years or older. Each state should be visualized as a point, rather than a bar, and there 
# should be 51 points, ordered by their value.  All labels should be readable. 


### 2: The swing justice 

# Using the `justices_court-median.csv` dataset and building off of the plot that was given, 
# make an improved plot by implementing as many of the following changes (which hopefully improves the graph): 
  
# * Label axes 
# * Use a black-white background.
# * Change the breaks of the x-axis to print numbers for every decade, not just every two decades.
# * Plots each line in translucent gray, so the overlapping lines can be visualized clearly. 
#   (Hint: in ggplot the `alpha` argument controls the degree of transparency)
# * Limit the scale of the y-axis to [-5, 5] so that the outlier justice in the 60s is trimmed 
#   and the rest of the data can be seen more easily (also, who is that justice?)
# * Plot the ideal point of the justice who holds the "median" ideal point in a given term. To distinguish 
#   this with the others, plot this line separately in a very light red _below_ the individual justice's lines.
# * Highlight the trend-line of only the nine justices who are _currently_ sitting on SCOTUS. Make sure this is 
#   clearer than the other past justices. 
# * Add the current nine justice's names to the right of the endpoint of the 2016 figure, alongside their ideal point. 
# * Make sure the text labels do not overlap with each other for readability using the `ggrepel` package. 
# * Extend the x-axis label to about 2020 so the text labels of justices are to the right of the trend-lines.
# * Add a caption to your text describing the data briefly, as well as any features relevant for the reader 
#   (such as the median line and the trimming of the y-axis)



### 3: Don't sort by the alphabet 

# The Figure we made that shows racial composition by state has one notable shortcoming: it orders the states 
# alphabetically, which is not particularly useful if you want see an overall pattern, without having particular 
# states in mind. 

# Find a way to modify the figures so that the states are ordered by the proportion of White residents in the sample. 



### 4 What to show and how to show it 

# As a student of politics our goal is not necessarily to make pretty pictures, but rather make pictures that 
# tell us something about politics, government, or society. If you could augment either the census dataset or 
# the justices dataset in some way, what would be an substantively significant thing to show as a graphic? 



  