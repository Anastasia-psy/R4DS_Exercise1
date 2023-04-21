library(rwhatsapp)
covfefe_chat <- rwa_read(
  here::here("exam", "covfefe_chat.txt"),
  encoding = "UTF-8"
)
library(dplyr, warn.conflicts = FALSE)
glimpse(covfefe_chat)

#Q1
# Who sent the highest number of messages?
covfefe_chat %>%
  mutate(day = date(time)) %>%
  count(author) %>%   filter(n %in% tail(sort(unique(n)),1)) %>% 
  arrange(desc(n))
  

#OR You can make a plot
covfefe_chat %>%
  mutate(day = date(time)) %>%
  count(author) %>% 
  print(n=32) %>% 
ggplot(aes(x = reorder(author, n), y = n)) +
  geom_bar(stat = "identity") +
  ylab("") + xlab("") +
  coord_flip() +
  ggtitle("Number of messages")

#Q2
# How many messages were exchanged during December 2022? Tip: Check the functions exported
# by lubridate package if you need to extract the “month” from the time field

library(lubridate)
library(dplyr)
# Answer
covfefe_chat %>% 
  mutate(Month = lubridate::month(time, label = FALSE),
         Year = lubridate::year(time), DayMonth = format(as.Date(time), "%y-%m")) %>%
  count(DayMonth) %>%  filter(DayMonth == '22-12')

#Addition 
# sorting wrt to highest messages
covfefe_chat %>% 
  mutate(Month = lubridate::month(time, label = FALSE),
         Year = lubridate::year(time), DayMonth = format(as.Date(time), "%y-%m")) %>%
  count(DayMonth) %>% filter(n %in% tail(sort(unique(n)),1)) %>% 
  arrange(desc(n))

#General Coding for making col such as Month, Year, Day&Month
covfefe_chat %>% 
  mutate(Month = lubridate::month(time, label = FALSE),
         Year = lubridate::year(time)) %>%  print(n=6) 

library(dplyr)
covfefe_chat %>% 
  mutate(Month = lubridate::month(time, label = FALSE),
         Year = lubridate::year(time), DayMonth = format(as.Date(time), "%d-%m"))
# Just for day
covfefe_chat %>% 
  mutate(Month = lubridate::month(time, label = FALSE),
         Year = lubridate::year(time), Day = format(as.Date(time), "%d") )


#Q3
# Who sent the first message of the current year? At which time?

glimpse(covfefe_chat)
covfefe_chat %>% filter(time > '2022-12-31') %>%  slice(1) 

#filter between dates
covfefe_chat %>%  
filter(between(time, as.Date('2023-01-01'), as.Date('2023-04-19'))) %>%
slice(1)



#Q4
# On which day did we exchange the highest number of messages? After filtering the corresponding
# text messages, check their content and try to explain the anomalous behaviour.
glimpse(covfefe_chat)

covfefe_chat %>%  mutate(Day = format(as.Date(time), "%d")) %>%
  count(text, Day) %>% slice(which.max(n))



#Q5
# How many messages are sent on average per day?

covfefe_chat %>% mutate(day = date(time)) %>%
  count(day) %>%
  summarise(APD = mean(n)) 
# 14.5 messages echanged per day
  
#Alternative
covfefe_chat %>%
  mutate(day = date(time)) %>%
  count(day) %>%
  summarise(TND = length(n), SOM = sum(n), APDM= mean(n))
# TND total number of days that messages have been exchanged
# SOM sum of all messages
# Average per day messages



#Q6
# Who sent the highest number of messages which included at least one emoji? Tip: As we can see
# from the output of glimpse(), the emoji column is a <list> column. The following code can be
# used to select only the not-NULL values from a list-column named col in a dataset named data:
#  data |> filter(!vapply(col, is.null, logical(1))).

glimpse(covfefe_chat)

covfefe_chat %>% filter(emoji)
  filter(!vapply(emoji, is.null, logical(1)))

head(covfefe_chat$emoji_name)



#highest number of messages sent on the specific date
covfefe_chat %>%
  mutate(day = date(time)) %>%
  count(day)%>% filter(n %in% tail(sort(unique(n)),1)) %>% 
  arrange(desc(n))



#Q7

# (Difficult) Determine the most common emoji for each author. In case of ties, you can select
# any of the equally-used emojies. Tip: The unnest() function (which is defined in the R package
# tidyr) can be used to “unnest” a list column. See the corresponding help page and the vignette of
# rwhatsapp for more details. In any case, you don’t need to “parse” the UTF-8 codes.

library("ggimage")
emoji_data <- rwhatsapp::emojis %>% # data built into package
  mutate(hex_runes1 = gsub("\\s.*", "", hex_runes)) %>% # ignore combined emojis
  mutate(emoji_url = paste0("https://abs.twimg.com/emoji/v2/72x72/", 
                            tolower(hex_runes1), ".png"))


covfefe_chat %>%
  top_n_emojis(emoji, n = 50)  %>% print(n =50)


to_remove <- c(stopwords(language = "de"),
               "party popper",
               "star-struck",
               "partying face", "thumbs up",
               "party popper ", "hot beverage",
               "folded hands: light skin tone",
               "crying face", "beer mug",
               "raised hand","man raising hand: light skin tone", "thinking", "hugs","pensive face",
               "sake", "cry", "beer", "upside-down face", "face with tears of joy",
               "hand with fingers splayed", "downcast face with sweat", "thumbs up: light skin tone","fountain", "man raising hand", "grinning face with sweat",
               "sake", "clinking beer mugs", " smiling face with tear", "sun", "face savoring food",
               "smiling face", "clinking beer mugs", "pensive", "frowning face", "rolling on the floor laughing",
               "smiling face with halo","Santa Claus", "Christmas tree","	confetti ball",
               "woman raising hand: light skin tone", "beers", "tumbler glass", "zany face", 
               "heart", "grinning face with sweat", "grinning face with smiling eyes", "see-no-evil monkey",
               "grinning face", "hugging face", "smiling face with sunglasses", "clapping hands: light skin tone",
               "loudly crying face", "thumbs down: light skin tone", "crying face",
               "woman dancing: medium skin tone", "thinking face",
               "blue heart", "woman teacher: light skin tone", "grimacing face")


covfefe_chat %>%
  unnest(emoji_name) %>%
  filter(!emoji_name %in% to_remove) %>%
  count(author, emoji_name, sort = TRUE) %>%
  group_by(author) %>%
  top_n(n = 6, n) %>%
  ggplot(aes(x = reorder_within(emoji_name, n, author), y = n, fill = author)) +
  geom_col(show.legend = FALSE) +
  ylab("") +
  xlab("") +
  coord_flip() +
  facet_wrap(~author, ncol = 2, scales = "free_y") +
  scale_x_reordered() +
  ggtitle("Most often used words")


#################################


covfefe_chat %>%
  top_n_emojis(emoji, n = 50)  %>% print(n =50)


to_remove <- c(stopwords(language = "de"),
               "+1",
               "-1",
               "Mrs_Claus_dark_skin_tone", "Mrs_Claus_light_skin_tone",
               "Leo ", "Libra",
               "Japanese_vacancy_button",
               "Japanese_secret_button", "Japanese_symbol_for_beginner",
               "Capricorn","Japanese_passing_grade_button", "thinking", "hugs","grimacing",
               "female_sign", "cry", "beer", "CL_button", "CL_button",
               "Aries", "clap", "Santa_Claus","-1", "smiling face with tear",
               "sake", "rofl", "relaxed", "innocent", "flexed biceps light_skin_tone",
               "face_screaming_in_fear", "Christmas_tree", "pensive", "star_struck", "slightly_smiling_face",
               "person_raising_hand","grinning face with sweat", "blush","star_struck",
               "party_popper", "beers", "relaxed","blue_heart", "heart", "flexed_biceps", "grinning face with smiling eyes")


covfefe_chat %>%
  unnest(emoji) %>%
  filter(!emoji %in% to_remove) %>%
  count(author, emoji, sort = TRUE) %>%
  group_by(author) %>%
  top_n(n = 6, n) %>%
  ggplot(aes(x = reorder_within(emoji, n, author), y = n, fill = author)) +
  geom_col(show.legend = FALSE) +
  ylab("") +
  xlab("") +
  coord_flip() +
  facet_wrap(~author, ncol = 2, scales = "free_y") +
  scale_x_reordered() +
  ggtitle("Most often used words")

################################################
