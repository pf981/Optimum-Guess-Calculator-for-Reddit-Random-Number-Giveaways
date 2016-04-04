#**************************************************************************************************
#
# TITLE:       Reddit Number Extractor
#
# DESCRIPTION:
#
#**************************************************************************************************

if (!require('pacman'))
    install.packages('pacman')

pacman::p_load('ggplot2',
               'RedditExtractoR',
               'tidyr')


MIN_GUESS <- 0
MAX_GUESS <- 999

post_url <- 'https://www.reddit.com/r/RandomActsOfGaming/comments/4d65cb/giveaway_south_park_the_stick_of_truth_steam_key/'




## Extract the comments from Reddit ####


comment_data <- reddit_content(post_url)




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


ggplot(smoothed, aes(x=x, y=1, fill=y)) +
    labs(title='Density of Guessed Numbers',
         y='',
         x='Guessed Number') +
    theme(axis.ticks=element_blank(), axis.text.y=element_blank()) +
    xlim(MIN_GUESS, MAX_GUESS) +
    scale_fill_continuous(name='Density') +
    geom_tile()




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


message('The best new guess that can be made is ', best_guess, ' which covers ', longest_false_run_length %/% 2, ' numbers.')















