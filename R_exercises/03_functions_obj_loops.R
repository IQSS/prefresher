# Objects, Functions, Loops


### Where are we? Where are we headed?

# Up till now, you should have covered:
#   
# * R basic programming
# * Data Import
# * Statistical Summaries
# * Visualization
# 
# 
# Today we'll cover
# 
# * Objects
# * Functions
# * Loops


## What is an object?

# Now that we have covered some hands-on ways to use graphics, let's go into some fundamentals of the R language. 

# Let's first set up 
library(dplyr)
library(readr)
library(haven)
library(ggplot2)



cen10 <- read_csv("data/input/usc2010_001percent.csv", col_types = cols())



# Objects are abstract symbols in which you store data. Here we will create an object from `copy`, and assign `cen10` to it. 

copy <- cen10 

# This looks the same as the original dataset:
copy


# What happens if you do this next?

copy <- ""


# It got reassigned:

copy



### lists

# Lists are one of the most generic and flexible type of object. You can make an empty list by the function `list()`

my_list <- list()
my_list


# And start filling it in. Slots on the list are invoked by double square brackets `[[]]`

my_list[[1]] <- "contents of the first slot -- this is a string"
my_list[["slot 2"]] <- "contents of slot named slot 2"
my_list


# each slot can be anything. What are we doing here? We are defining the 1st slot of the list `my_list` 
# to be a vector `c(1, 2, 3, 4, 5)`

my_list[[1]] <- c(1, 2, 3, 4, 5)
my_list


# You can even make nested lists. Let's say we want the 1st slot of the list to be another list of three elements. 

my_list[[1]][[1]] <- "subitem 1 in slot 1 of my_list"
my_list[[1]][[2]] <- "subitem 1 in slot 2 of my_list"
my_list[[1]][[3]] <- "subitem 1 in slot 3 of my_list"

my_list



## Making your own objects
# We've covered one type of object, which is a list. You saw it was quite flexible. How many types of objects are there? 

# There are an infinite number of objects, because people make their own class of object. You can detect the type of 
# the object (the class) by the function `class`

Object can be said to be an instance of a class.

# Analogies: 
# 
# class - Pokemon, object - Pikachu
# 
# class - Book, object - To Kill a Mockingbird
# 
# class - DataFrame, object - 2010 census data
# 
# class - Character, object - "Programming is Fun"
#            

# What is type (class) of object is `cen10`?
class(cen10)

# What about this text? 

class("some random text")



# To change or create the class of any object, you can _assign_ it. To do this, assign the 
# name of your class to character to an object's `class()`. 

# We can start from a simple list. For example, say we wanted to store data about pokemon. 
# Because there is no pre-made package for this, we decide to make our own class. 

pikachu <- list(name = "Pikachu",
                number = 25,
                type = "Electric",
                color = "Yellow")

# and we can give it any class name we want. 

class(pikachu) <- "Pokemon"
str(pikachu)
pikachu$type



### Seeing R through objects
# Most of the R objects that you will see as you advance are their own objects. For example, 
# here's a linear regression object (which you will learn more about in Gov 2000):

ols <- lm(mpg ~ wt + vs + gear + carb, mtcars)
class(ols)


# Anything can be an object! Even graphs (in `ggplot`) can be assigned, re-assigned, and edited. 

grp_race <- group_by(cen10, race)%>%
  summarize(count = n())

grp_race_ordered <- arrange(grp_race, count) %>% 
  mutate(race = forcats::as_factor(race))

gg_tab <- ggplot(data = grp_race_ordered) +
  aes(x = race, y = count) +
  geom_col() +
  labs(caption = "Source: U.S. Census 2010")

gg_tab


# You can change the orientation

gg_tab<- gg_tab + coord_flip()

gg_tab



### Parsing an object by `str()s`
# It can be hard to understand an `R` object because it's contents are unknown. The function `str`, 
# short for structure, is a quick way to look into the innards of an object

str(my_list)
class(my_list)


# Same for the object we just made

str(pikachu)



# What does a `ggplot` object look like? Very complicated, but at least you can see it:

str(gg_tab)



## Types of variables
# In the social science we often analyze variables. As you saw in the tutorial, different types of 
# variables require different care. 

# A key link with what we just learned is that variables are also types of R objects. 

### scalars
# One number. How many people did we count in our Census sample?

nrow(cen10)


# Question: What proportion of our census sample is Native American? This number is also a scalar

unique(cen10$race)
mean(cen10$race == "American Indian or Alaska Native")


# Hint: you can use the function `mean()` to calcualte the sample mean. The sample proportion is the mean of a 
# sequence of number, where your event of interest is a 1 (or `TRUE`) and others are 0 (or `FALSE`).


### numeric vectors

# A sequence of numbers. 


grp_race_ordered$count
class(grp_race_ordered$count)


# Or even, all the ages of the millions of people in our Census. Here are just the first few numbers of the list. 

head(cen10$age)


### characters (aka strings)

# This can be just one stretch of characters 

my_name <- "Meg"
my_name
class(my_name)


# or more characters. Notice here that there's a difference between a vector of individual characters 
# and a length-one object of characters.

my_name_letters <- c("M","e","g")
my_name_letters
class(my_name_letters)


# Finally, remember that lower vs. upper case matters in R!

my_name2 <- "meg"
my_name == my_name2




## What is a function?

# Most of what we do in R is executing a function. `read_csv()`, `nrow()`, `ggplot()` .. pretty much anything 
# with a parentheses is a function. And even things like `<-` and `[` are functions as well.

# A function is a set of instructions with specified ingredients. It takes an input, then 
# manipulates it -- changes it in some way -- and then returns the manipulated product. 

# One way to see what a function actually does is to enter it without parentheses. 

table


# You'll see below that the most basic functions are quite complicated internally. 

# You'll notice that functions contain other functions. wrapper functions are functions that 
# "wrap around" existing functions. This sounds redundant, but it's an important feature of 
# programming. If you find yourself repeating a command more than two times, you should make your 
# own function, rather than writing the same type of code. 


### Write your own function
# It's worth remembering the basic structure of a function. You create a new function, call it `my_fun` by this:

my_fun <- function() {
  # put content here
}


# If we wanted to generate a function that computed the number of men in your data, what would that look like?

count_men <- function(data) {
  
  nmen <- sum(data$sex == "Male")
  
  return(nmen)
}



# Then all we need to do is feed this function a dataset

count_men(cen10)


# The point of a function is that you can use it again and again without typing up the set of 
# constituent manipulations. So, what if we wanted to figure out the number of men in California?

count_men(cen10[cen10$state == "California",])



# Let's go one step further. What if we want to know the proportion of non-whites in a state, just 
# by entering the name of the state? There's multiple ways to do it, but it could look something like this

nw_in_state <- function(data, state) {
  
  s.subset <- data[data$state == state,]
  total.s <- nrow(s.subset)
  nw.s <- sum(s.subset$race != "White")
  
  nw.s / total.s
}


# The last line is what gets generated from the function. To be more explicit you can wrap the last 
# line around `return()`. (as in `return(nw.s/total.s`). `return()` is used when you want to break out of a function in the middle of it and not wait till the last line.

# Try it on your favorite state!

nw_in_state(cen10, "Massachusetts")



## Checkpoint


### 1

# Try making your own function, `average_age_in_state`, that will give you the average age of people in a given state.





### 2

# Try making your own function, `asians_in_state`, that will give you the number of `Chinese`, `Japanese`, 
# and `Other Asian or Pacific Islander` people in a given state.


### 3 

# Try making your own function, 'top_10_oldest_cities', that will give you the names of cities whose 
# population's average age is top 10 oldest. 



## What is a package?
# You can think of a package as a suite of functions that other people have already built for 
# you to make your life easier. 

help(package = "ggplot2")



# To use a package, you need to do two things: (1) install it, and then (2) load it. 

# Installing is a one-time thing

install.packages("ggplot2")


# But you need to load each time you start a  R instance. So always keep these commands on a script.

library(ggplot2)



# In `rstudio.cloud`, we already installed a set of packages for you. But when you start your own R 
# instance, you need to have installed the package at some point. 

## Conditionals

# Sometimes, you want to execute a command only under certain conditions. This is done through the 
# almost universal function, `if()`. Inside the `if` function we enter a logical statement. 
# The line that is adjacent to, or follows, the `if()` statement only gets executed if the 
# statement returns `TRUE`. 

x <- 5
if (x >0) {
  print("positive number")
} else if (x == 0)  {
  print ("zero")
} else {
  print("negative number")
}


# You can wrap that whole things in a function 

is_positive <- function(number) {
  if (number > 0) {
    print("positive number")
  } else if (number == 0)  {
    print ("zero")
  } else {
    print("negative number")
  }
}

is_positive(5)
is_positive(-3)



## For-loops

# Loops repeat the same statement, although the statement can be "the same" only in an abstract sense.  
# Use the `for(x in X)` syntax to repeat the subsequent command as many times as there are elements in the 
# right-hand object `X`. Each of these elements will be referred to the left-hand index `x`

# First, come up with a vector. 

fruits <- c("apples", "oranges", "grapes")


# Now we use the `fruits` vector in a `for` loop.

for (fruit in fruits) {
  print(paste("I love", fruit))
}


# Here `for()` and `in` must be part of any for loop. The right hand side `fruits` must be a thing 
# that exists. Finally the `left-hand` side object is "Pick your favor name." It is analogous to how we 
# can index a sum with any letter. $\sum_{i=1}^{10}i$ and `sum_{j = 1}^{10}j` are in fact the same thing.


for (i in 1:length(fruits)) {
  print(paste("I love", fruits[i]))
}



states_of_interest <- c("California", "Massachusetts", "New Hampshire", "Washington")

for( state in states_of_interest){
  state_data <- cen10[cen10$state == state,]
  nmen <- sum(state_data$sex == "Male")
  
  n <- nrow(state_data)
  men_perc <- round(100*(nmen/n), digits=2)
  print(paste("Percentage of men in",state, "is", men_perc))
  
}



# Instead of printing, you can store the information in a vector

states_of_interest <- c("California", "Massachusetts", "New Hampshire", "Washington")
male_percentages <- c()
iter <-1 

for( state in states_of_interest){
  state_data <- cen10[cen10$state == state,]
  nmen <- sum(state_data$sex == "Male")
  n <- nrow(state_data)
  men_perc <- round(100*(nmen/n), digits=2)
  
  male_percentages <- c(male_percentages, men_perc)
  names(male_percentages)[iter] <- state
  iter <- iter + 1
}

male_percentages


## Nested Loops

# What if I want to calculate the population percentage of a race group for all race groups in states of interest?
  # You could probably use tidyverse functions to do this, but let's try using loops!

states_of_interest <- c("California", "Massachusetts", "New Hampshire", "Washington")
for (state in states_of_interest) {
  for (race in unique(cen10$race)) {
    race_state_num <- nrow(cen10[cen10$race == race & cen10$state == state, ])
    state_pop <- nrow(cen10[cen10$state == state, ])
    race_perc <- round(100*(race_state_num/(state_pop)), digits=2)
    print(paste("Percentage of ", race , "in", state, "is", race_perc))
  }
}

## Exercises

 
### Exercise 1: Write your own function
# Write your own function that makes some task of data analysis simpler. Ideally, it would be a 
#  function that helps you do either of the previous tasks in fewer lines of code. You can use 
# the three lines of code that was provided in exercise 1 to wrap that into another function too!




### Exercise 2: Using Loops

# Using a loop, create a crosstab of sex and race for each state in the set "states_of_interest"

states_of_interest <- c("California", "Massachusetts", "New Hampshire", "Washington")




### Exercise 3: Storing information derived within loops in a global dataframe

# Recall the following nested loop

states_of_interest <- c("California", "Massachusetts", "New Hampshire", "Washington")
for (state in states_of_interest) {
  for (race in unique(cen10$race)) {
    race_state_num <- nrow(cen10[cen10$race == race & cen10$state == state, ])
    state_pop <- nrow(cen10[cen10$state == state, ])
    race_perc <- round(100*(race_state_num/(state_pop)), digits=2)
    print(paste("Percentage of ", race , "in", state, "is", race_perc))
  }
}


# Instead of printing the percentage of each race in each state, create a dataframe, and store all that 
# information in that dataframe. (Hint: look at how I stored information about male percentage in each 
# state of interest in a vector.)


