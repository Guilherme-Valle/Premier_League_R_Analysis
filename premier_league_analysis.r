# Dataset -> https://github.com/footballcsv/england

install.packages("BBmisc")
library(BBmisc)
install.packages("dplyr")
library(dplyr)
install.packages("tidyr")
library(stringr)
library(tidyr)
library(ggplot2)

# Leitura do csv
pl_games <- read.csv("~/Documents/Datasets/England/combined_csv.csv")
head(pl_games)
str(pl_games)

# Quebra campo de placar em duas colunas distintas
pl_games$Team1.Goals <- sapply(strsplit(as.character(pl_games$FT), '-'), "[", 1)
pl_games$Team2.Goals <- sapply(strsplit(as.character(pl_games$FT), '-'), "[", 2)
# Formata datas dos jogos
pl_games$Date <- as.Date(pl_games$Date, format = "%a %b %d %Y")

# Formata gols para inteiro
pl_games$Team1.Goals <- as.integer(pl_games$Team1.Goals)
pl_games$Team2.Goals <- as.integer(pl_games$Team2.Goals)

# Remove nulls
pl_games[is.na(pl_games)] <- 0
colSums(is.na(pl_games))

# Agrupa times por gols
group_team_1 <- pl_games %>% group_by(Team = Team.1) %>% summarise(Total_Scored = sum(Team1.Goals), Total_Suffered = sum(Team2.Goals))
group_team_2 <- pl_games %>% group_by(Team = Team.2) %>% summarise(Total_Scored = sum(Team2.Goals), Total_Suffered = sum(Team1.Goals))
pl_teams_goals <- full_join(group_team_1, group_team_2) %>% 
  group_by(Team) %>%
  summarise(Total_Scored = sum(Total_Scored), Total_Suffered = sum(Total_Suffered))
head(pl_teams_goals)

# Ordena por gols marcados e pega o top 6
pl_teams_goals_scored_big_6 <- pl_teams_goals[order(pl_teams_goals$Total_Scored, 
                                                    decreasing = TRUE),] %>%
                                                    slice(1:6)
head(pl_teams_goals_scored_big_6)

# Gráfico exibindo top 6
ggplot(data=pl_teams_goals_scored_big_6, 
       aes(x=Team, y=Total_Scored, fill = Team)) +
        geom_bar(stat='identity', width = 0.6) +
        theme_linedraw(base_size = 18) +
        xlab("Top 6 Premier League goals by team (1997-2020)") +
        ylab("Scored goals") +
        theme(axis.title = element_text(size = 26))
