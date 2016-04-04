#***************************************************************************************************
#
# TITLE:       Optimum Guess Calculator for Reddit Random Number Giveaways
#
# DESCRIPTION: Various Reddit giveaway posts involve the poster randomly choosing a number and the
#              commenter who comments the number closest to this is the winner. See the following
#              URL for an example of a giveaway post:
#                  https://www.reddit.com/r/RandomActsOfGaming/comments/4d65cb/giveaway_south_park_the_stick_of_truth_steam_key/
#
#              This code is used to calculate the optimal guess by finding the middle of the biggest
#              gap in the guesses. It downloads all the comments, extracts the numbers, plots the
#              density of guesses and outputs the optimum number to guess.
#
# INPUTS:      This code requires MIN_GUESS, MAX_GUESS and post_url to be specified.
#
#***************************************************************************************************

if (!require('pacman'))
    install.packages('pacman')

pacman::p_load('ggplot2',
               'RedditExtractoR',
               'tidyr')




## Inputs ####


MIN_GUESS <- 0
MAX_GUESS <- 999
POST_URL <- 'https://www.reddit.com/r/RandomActsOfGaming/comments/4d65cb/giveaway_south_park_the_stick_of_truth_steam_key/'




## Extract the comments from Reddit ####


comment_data <- reddit_content(POST_URL)




## Extract the Guessed Numbers in the Comments ####


guessed_numbers <- comment_data$comment %>%
    unlist %>%
    strsplit('[^0-9]+') %>%
    unlist %>%
    as.numeric %>%
    na.omit %>%
    unique %>%
    sort

guess_df <- data.frame(number=seq(from=MIN_GUESS, to=MAX_GUESS, by=1))
guess_df$is_guessed <- guess_df$number %in% guessed_numbers




## Plot the Density of the Guesses ####


smoothed <- density(guessed_numbers, adjust=0.1) # You may need to tune the adjust parameter
smoothed <- data.frame(x=smoothed$x, y=smoothed$y)

# Plot a 1D density plot
# The darker sections indicate larger gaps in guesses
ggplot(smoothed, aes(x=x, y=1, fill=y)) +
    labs(title='Density of Guessed Numbers',
         y='',
         x='Guessed Number') +
    theme(axis.ticks=element_blank(), axis.text.y=element_blank()) +
    xlim(MIN_GUESS, MAX_GUESS) +
    scale_fill_continuous(name='Density') +
    geom_tile()

# Plot a 2D density plot
# The lower points indicate larger gaps in guesses
ggplot(data.frame(number=guessed_numbers), aes(x=number, fill=1)) +
    labs(title='Density of Guessed Numbers',
         y='Density',
         x='Guessed Number') +
    theme(legend.position = "none") +
    geom_density(adjust=0.1)




## Find the Bigest Gap in the Guesses ####


run_lengths <- rle(guess_df$is_guessed) %>%
    unclass %>%
    data.frame

# Find the biggest gap in the guessses. Gaps are simply runs of FALSE.
only_false_lengths <- ifelse(!run_lengths$values, run_lengths$lengths, 0)
longest_false_run_index <- which.max(only_false_lengths)
longest_false_run_length <- only_false_lengths[longest_false_run_index]

# Determine the beginning and end of the gap
start_of_longest_gap <- cumsum(run_lengths$lengths)[longest_false_run_index-1]
end_of_longest_gap <- start_of_longest_gap + longest_false_run_length

# Determine the middle of the gap
best_guess <- (start_of_longest_gap + end_of_longest_gap - 1) %/% 2


message('The best new guess that can be made is ',
        best_guess,
        ' which covers ',
        longest_false_run_length %/% 2,
        ' numbers.')















