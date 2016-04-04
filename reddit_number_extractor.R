#**************************************************************************************************
#
# TITLE:       Reddit Number Extractor
#
# DESCRIPTION:
#
#**************************************************************************************************

if (!require('pacman'))
    install.packages('pacman')

pacman::p_load('RedditExtractoR',
               'tidyr')
# pacman::p_load('RedditExtractoR',
#                'tidyr',
#                'tm')



comment_data <- reddit_content('https://www.reddit.com/r/RandomActsOfGaming/comments/4d65cb/giveaway_south_park_the_stick_of_truth_steam_key/')





# comments <- comment_data$comment %>%
#     unlist %>%
#     gsub('[^0-9]', '', .) %>%
#     strsplit('') %>%
#     unlist %>%
#     as.numeric %>%
#     unique


guessed_numbers <- comment_data$comment %>%
    unlist %>%
    strsplit('[^0-9]+') %>%
    unlist %>%
    as.numeric %>%
    na.omit %>%
    unique %>%
    sort



unique(as.numeric(unlist(strsplit(gsub("[^0-9]", "", unlist(ll)), ""))))




