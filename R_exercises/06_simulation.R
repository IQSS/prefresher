# Simulation

library(dplyr)


### Where are we? Where are we headed?

# Up till now, you should have covered:
#   
# * `R` basics
# * Visualization
# * Matrices and vectors
# * Functions, objects, loops
# * Joining real data
# 
# 
# In this module, we will start to work with generating data within R, from thin air, 
# as it were. Doing simulation also strengthens your understanding of Probability.


### Check your Understanding

# * What does the `sample()` function do?
# * What does `runif()` stand for?
# * What is a `seed`?
# * What is a Monte Carlo?
#   
#   
# Check if you have an idea of how you might code the following tasks:
#   
# * Simulate 100 rolls of a die
# * Simulate one random ordering of 25 numbers
# * Simulate 100 values of white noise (uniform random variables)
# * Generate a "bootstrap" sample of an existing dataset

# We're going to learn about this today!


## Motivation: Simulation as an Analytical Tool

# An increasing amount of political science contributions now include a simulation.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       Statistical Software, 45(7), 1-47.](http://www.jstatsoft.org/v45/i07/)])

# Statistical methods also incorporate simulation: 
  
# * The bootstrap: a statistical method for estimating uncertainty around some parameter by re-sampling observations. 
# * Bagging: a method for improving machine learning predictions by re-sampling observations, storing the estimate 
#   across many re-samples, and averaging these estimates to form the final estimate. A variance reduction technique. 
# * Statistical reasoning: if you are trying to understand a quantitative problem, a wonderful first-step to 
#   understand the problem better is to simulate it! The analytical solution is often very hard (or impossible), but the simulation is often much easier :-) 


## Pick a sample, any sample

## The `sample()` function

# The core functions for coding up stochastic data revolves around several key functions, 
# so we will simply review them here.  

# Suppose you have a vector of values `x` and from it you want to randomly sample a sample of 
# length `size`. For this, use the `sample` function

sample(x = 1:10, size = 5)


# There are two subtypes of sampling -- with and without replacement.

# 1. Sampling without replacement (`replace = FALSE`) means once an element of `x` is chosen, 
# it will not be considered again:

sample(x = 1:10, size = 10, replace = FALSE) ## no number appears more than once


# 2. Sampling with replacement (`replace = TRUE`) means that even if an element of `x` is 
# chosen, it is put back in the pool and may be chosen again. 

sample(x = 1:10, size = 10, replace = TRUE) ## any number can appear more than once


# It follows then that you cannot sample without replacement a sample that is larger than the pool.

sample(x = 1:10, size = 100, replace = FALSE)



# So far, every element in `x` has had an equal probability of being chosen. In some application, 
# we want a sampling scheme where some elements are more likely to be chosen than others. 
# The argument `prob` handles this.

# For example, this simulates 20 fair coin tosses (each outcome is equally likely to happen)

sample(c("Head", "Tail"), size = 20, prob = c(0.5, 0.5), replace = TRUE)


# But this simulates 20 biased coin tosses, where say the probability of Tails is 4 times 
# more likely than the number of Heads

sample(c("Head", "Tail"), size = 20, prob = c(0.2, 0.8), replace = TRUE)


### Sampling rows from a dataframe

# In tidyverse, there is a convenience function to sample rows randomly: `sample_n()` and `sample_frac()`. 

# For example, load the dataset on cars, `mtcars`, which has 32 observations.

mtcars

# sample_n picks a user-specified number of rows from the dataset:

sample_n(mtcars, 3)


# Sometimes you want a X percent sample of your dataset. In this case use `sample_frac()`

sample_frac(mtcars, 0.10)


# As a side-note, these functions have very practical uses for any type of data analysis:
  
# * Inspecting your dataset: using `head()` all the same time and looking over the first few rows might lead you to 
#   ignore any issues that end up in the bottom for whatever reason.
# * Testing your analysis with a small sample: If running analyses on a dataset takes more than a handful of seconds, 
#   change your dataset upstream to a fraction of the size so the rest of the code runs in less than a second. 
#   Once verifying your analysis code runs, then re-do it with your full dataset (by simply removing the 
#   `sample_n` / `sample_frac` line of code in the beginning). While three seconds may not sound like much, 
#   they accumulate and eat up time.


## Random numbers from specific distributions

### `rbinom()` 
# `rbinom` builds upon `sample` as a tool to help you answer the question -- what is the 
#  total number of successes I would get if I  sampled a binary (Bernoulli) result from a 
#  test with `size` number of trials each, with a event-wise probability of `prob`. 
# The first argument `n` asks me how many such numbers I want.

# For example, I want to know how many Heads I would get if I flipped a fair coin 100 times. 

rbinom(n = 1, size = 100, prob = 0.5)


# Now imagine this I wanted to do this experiment 10 times, which would require I flip the 
# coin 10 x 100 = 1000 times! Helpfully, we can do this in one line

rbinom(n = 10, size = 100, prob = 0.5)


### `runif()` 
# `runif` also simulates a stochastic scheme where each event has equal probability of getting chosen like 
# `sample`, but is a continuous rather than discrete system.  We will cover this more in the next math module.

# The intuition to emphasize here is that one can generate potentially infinite amounts (size `n`) of noise 
# that is a essentially random

runif(n = 5)


### `rnorm()`

# `rnorm` is also a continuous distribution, but draws from a Normal distribution -- 
# perhaps the most important distribution in statistics. It runs the same way as `runif`

rnorm(n = 5)


# To better visualize the difference between the output of `runif` and `rnorm`, let's 
# generate lots of each and plot a histogram.

from_runif <- runif(n = 1000)
from_rnorm <- rnorm(n = 1000)

par(mfrow = c(1, 2)) ## base-R parameter for two plots at once
hist(from_runif)
hist(from_rnorm)



## r, p, and d

# Each distribution can do more than generate random numbers (the prefix `r`).
# We can compute the cumulative probability by the function `pbinom()`, `punif()`, and 
# `pnorm()`. Also the density -- the value of the PDF -- by `dbinom()`, `dunif()` and `dnorm()`.  


## `set.seed()`

# `R` doesn't have the ability to generate truly random numbers! Random numbers are actually 
# very hard to generate. (Think: flipping a coin --> can be perfectly predicted if I know wind 
# speed, the angle the coin is flipped, etc.). Some people use random noise in the atmosphere 
# or random behavior in quantum systems to generate "truly" (?) random numbers. Conversely, 
# R uses deterministic algorithms which take as an input a "seed" and which then perform a 
# series of operations to generate a sequence of random-seeming numbers (that is, numbers 
# whose sequence is sufficiently hard to predict).

# Let's think about this another way. Sampling is a stochastic process, so every time you run 
# `sample()` or `runif()` you are bound to get a different output (because different random 
# seeds are used). This is intentional in some cases but you might want to avoid it in others. 
# For example, you might want to diagnose a coding discrepancy by setting the random number 
# generator to give the same number each time. To do this, use the function `set.seed()`.

# In the function goes any number. When you run a sample function in the same command as a 
# preceding `set.seed()`, the sampling function will always give you the same sequence of 
# numbers. In a sense, the sampler is no longer random (in the sense of unpredictable to use; 
# remember: it never was "truly" random in the first place)


set.seed(02138)
runif(n = 10)


# The random number generator should  give you the exact same sequence of numbers if you precede 
# the function by the same seed, 

set.seed(02138)
runif(n = 10)





## Exercises

### Census Sampling 

# What can we learn from surveys of populations, and how wrong do we get if our sampling is biased?

# Suppose we want to estimate the proportion of U.S. residents who are non-white (`race != "White"`). 
# In reality, we do not have any population dataset to utilize and so we _only see the sample survey_. 
# Here, however, to understand how sampling works, let's conveniently use the Census extract in some 
# cases and pretend we didn't in others.


# (a) First, load `usc2010_001percent.csv` into your R session. After loading the `library(tidyverse)`, 
# browse it. Although this is only a 0.01 percent extract, treat this as your population for pedagogical 
# purposes. What is the population proportion of non-White residents?




# (b) Setting a seed to `1669482`, sample 100 respondents from this sample. What is the proportion of 
# non-White residents in this _particular_ sample? By how many percentage points are you off from 
# (what we labelled as) the true proportion?




# (c) Now imagine what you did above was one survey. What would we get if we did 20 surveys? 

# To simulate this, write a loop that does the same exercise 20 times, each time computing a sample proportion. 
# Use the same seed at the top, but be careful to position the `set.seed` function such that it generates 
# the same sequence of 20 samples, rather than 20 of the same sample. 

# Try doing this with a `for` loop and storing your sample proportions in a new length-20 vector. 
# (Suggestion: make an empty vector first as a container). After running the loop, show a histogram 
# of the 20 values. Also what is the average of the 20 sample estimates?



# (d) Now, to make things more real, let's introduce some response bias. The goal here is not to 
# correct response bias but to induce it and see how it affects our estimates.  Suppose that 
# non-White residents are 10 percent less likely to respond to enter your survey than White respondents. 
# This is plausible if you think that the Census is from 2010 but you are polling in 2018, and racial 
# minorities are more geographically mobile than Whites.  Repeat the same exercise in (c) by modeling 
# this behavior. 

# You can do this by creating a variable, e.g. `propensity`, that is 0.9 for non-Whites and 1 otherwise. 
# Then, you can refer to it in the propensity argument.



# (e) Finally, we want to see if more data ("Big Data") will improve our estimates. Using the 
# same unequal response rates framework as (d), repeat the same exercise but instead of each poll 
# collecting 100 responses, we collect 10,000. 




# (f) Optional - visualize your 2 pairs of 20 estimates, with a bar showing the "correct" 
# population average. 






### Conditional Proportions 

# This example is not on simulation, but is meant to reinforce some of the probability 
# discussion from math lecture. 

# Read in the Upshot Siena poll from Fall 2016, `data/input/upshot-siena-polls.csv`.

# In addition to some standard demographic questions, we will focus on one called `vt_pres_2` 
# in the csv. This is a two-way presidential vote question, asking respondents who they plan to 
# vote for President if the election were held today -- Donald Trump, the Republican, or Hilary Clinton, 
# the Democrat, with options for Other candidates as well. For this problem, use the two-way vote question 
# rather than the 4-way vote question. 

# (a)  Drop the the respondents who answered the November poll (i.e. those for which `poll == "November"`).
# We do this in order to ignore this November population in all subsequent parts of this question 
# because they were not asked the Presidential vote question. 



# (b) Using the dataset after the procedure in (a), find the proportion of poll respondents 
# (those who are in the sample) who support Donald Trump. 




# (c)  Among those who supported Donald Trump, what proportion of them has a Bachelor's degree or 
# higher (i.e. have a Bachelor's, Graduate, or other Professional Degree)?
  
  
# (d)  Among those who did not support Donald Trump (i.e. including supporters of Hilary Clinton, 
# another candidate, or those who refused to answer the question), what proportion of them has a 
# Bachelor's degree or higher? 


# (e)  Express the numbers in the previous parts as probabilities of specified events.  Define your 
# own symbols: For example, we can let T be the event that a randomly selected respondent in the 
# poll supports Donald Trump, then the proportion in part (b) is the probability P(T). 



# (f) Suppose we randomly sampled a person who participated in the survey and found that he/she 
# had a Bachelor's degree or higher. Given this evidence, what is the probability that the same 
# person supports Donald Trump? Use Bayes Rule and show your work -- that is, do not use data or R 
# to compute the quantity directly.  Then, verify this is the case via R.






### The Birthday problem

# Write code that will answer the well-known birthday problem via simulation

# The problem is fairly simple: Suppose $k$ people gather together in a room. 
# What is the probability at least two people share the same birthday?
  
# To simplify reality a bit, assume that (1) there are no leap years, and so there are always 
# 365 days in a year, and (2) a given individual's birthday is randomly assigned and independent 
# from each other. 


# Step 1: Set `k` to a concrete number. Pick a number from 1 to 365 randomly, `k` times 
# to simulate birthdays (would this be with replacement or without?).

# Your code:



# Step 2: Write a line (or two) of code  that gives a `TRUE` or `FALSE` statement of whether 
# or not at least two people share the same birth date.

# Your code:



# Step 3: The above steps will generate a `TRUE` or `FALSE` answer for your event of interest, 
# but only for one realization of an event in the sample space. In order to estimate the _probability_ 
# of your event happening, we need a "stochastic", as opposed to "deterministic", method. To do this, 
# write a loop that does Steps 1 and 2 repeatedly for many times, call that number of times `sims`. 
# For each of `sims` iteration, your code should give you a `TRUE` or `FALSE` answer. Code up a way 
# to store these estimates.

# Your code:



# Step 4: Finally, generalize the function further by letting `k` be a user-defined number. 
# You have now created a _Monte Carlo simulation_! 

# Your code:



# Step 5: Generate a table or plot that shows how the probability of sharing a birthday changes 
# by `k` (fixing `sims` at a large number like `1000`). Also generate a similar plot that shows 
# how the probability of sharing a birthday changes by `sims` (fixing `k` at some arbitrary number 
# like `10`). 

# Your code



# Extra credit: Give an "analytical" answer to this problem, that is an answer through deriving the 
# mathematical expressions of the probability.




