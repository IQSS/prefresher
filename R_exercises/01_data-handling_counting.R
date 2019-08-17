# Harvard Math Prefresher
# Programming Exercises

# Orientation and Reading in Data

# Loading packages
library(ggplot2)
library(dplyr)
library(fs)


## The Computer and You: Giving Instructions

# We'll do the Peanut Butter and Jelly Exercise in class as an introduction to programming for those who are new.
# 
# Assignment: Take 5 minutes to write down on a piece of paper, how to make a peanut butter and jelly sandwich. 
# Be as concise and unambiguous as possible so that a robot (who doesn't know what a PBJ is) would understand. 
# You can assume that there will be loaf of sliced bread, a jar of jelly, a jar of peanut butter, and a knife. 
# 
# Simpler assignment: Say we just want a robot to be able to tell us if we have enough ingredients to make a 
# peanut butter and jelly sandwich. Write down instructions so that if told how many slices of bread, servings 
# of peanut butter, and servings of jelly you have, the robot can tell you if you can make a PBJ.
# 
# Now, translate the simpler assignment into R code using the code below as a starting point:

n_bread <- 8
n_pb <- 3
n_jelly <- 9

# write instructions in R here






## A is for Athens

# For our first dataset, let's try reading in a dataset on the Ancient Greek world. Political Theorists and Political 
# Historians study the domestic systems, international wars, cultures and writing of this era to understand the first 
# instance of democracy, the rise and overturning of tyranny, and the legacies of political institutions. 
                                                                                                                                                                         
# This POLIS dataset was generously provided by Professor Josiah Ober of Stanford University. This dataset includes 
# information on city states in the Ancient Greek world, parts of it collected by careful work by historians and 
# archaeologists. It is part of his recent books on Greece (Ober 2015), "The Rise and Fall of Classical Greece"

### Locating the Data 
# What files do we have in the `data/input` folder?

dir_ls("data/input")


### Reading in Data
# In Rstudio, a good way to start is to use the GUI and the Import tool. Once you click a file, an option 
# to "Import Dataset" comes up. RStudio picks the right function for you, and you can copy that code, but 
# it's important to eventually be able to write that code yourself. 

# For the first time using an outside package, you first need to install it. 

install.packages("readxl")


# After that, you don't need to install it again. But you __do__ need to load it each time. 
library(readxl)

# The package `readxl` has a website: https://readxl.tidyverse.org/. Other packages are not as user-friendly, 
# but they have a help page with a table of contents of all their functions. 
help(package = readxl)


# From the help page, we see that `read_excel()` is the function that we want to use. 
# Let's try it. 
ober <- read_excel("data/input/ober_2018.xlsx")

# Review: what does the `/` mean?  Why do we need the `data` term first? Does the argument need to be in quotes? 


### Inspecting 

# For almost any dataset, you usually want to do a couple of standard checks first to understand what you loaded.
ober

dim(ober)

# From your tutorials, you also know how to do graphics! 
# Graphics are useful for grasping your data, but we will cover them more deeply in Chapter \@ref(dataviz).

ggplot(ober, aes(x = Fame)) + geom_histogram()


# What about the distribution of fame by regime?

ggplot(ober, aes(y = Fame, x = Regime, group = Regime)) +
  geom_boxplot()



## Exercises

### 1
# What is the Fame value of Delphoi?


### 2 
# Find the polis with the top 10 Fame values.


### 3 
# Make a scatterplot with the number of colonies on the x-axis and Fame on the y-axis.


### 4
# Find the correct function to read the following datasets (available in your rstudio.cloud session) into your R window.
# * `data/input/acs2015_1percent.csv`: A one percent sample of the American Community Survey
# * `data/input/gapminder_wide.tab`: Country-level wealth and health from Gapminder^[Formatted and taken from <https://doi.org/10.7910/DVN/GJQNEQ>]
# * `data/input/gapminder_wide.Rds`: A Rds version of the Gapminder (What is a Rds file? What's the difference?)
# * `data/input/Nunn_Wantchekon_sample.dta`: A sample from the Afrobarometer survey (which we'll explore tomorrow). `.dta` is a Stata format. 
# * `data/input/german_credit.sav`: A hypothetical dataset on consumer credit. `.sav` is a SPSS format. 
# 
# Our Recommendations: Look at the packages `haven` and `readr`





### 5
# Read Ober's codebook and find a variable that you think is interesting. Check the distribution of that variable 
# in your data, get a couple of statistics, and summarize it in English.




