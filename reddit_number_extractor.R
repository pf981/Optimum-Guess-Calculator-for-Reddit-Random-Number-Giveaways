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
# For deeper text mining, use tm package


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




# smoothed <- density(guessed_numbers, adjust = 1)
smoothed <- density(guessed_numbers, adjust=0.1)
smoothed <- data.frame(x=smoothed$x, y=smoothed$y)
# smoothed <- density(guessed_numbers, adjust = 1) %>%
#     select(x, y) %>%
#     data.frame

# smoothed$x
# smoothed$y


ggplot(smoothed, aes(x=x, y=1, fill=y)) +
    xlim(MIN_GUESS, MAX_GUESS) +
    geom_tile()


ggplot(guess_df, aes(x=number, y=1, fill=is_guessed)) + geom_tile()





ggplot(guess_df, aes(x=number, y=is_guessed)) +
    geom_histogram()



ggplot(guess_df, aes(x=number, y=is_guessed)) +
    geom_bar(stat='identity')


ggplot(guess_df, aes(x=number, y=is_guessed)) +
    geom_density()



ggplot(guess_df, aes(x=number, y=1, fill=is_guessed)) + geom_density(adjust=0.1)

# ggplot(guess_df, aes(x=number, y=is_guessed)) + geom_tile()





























