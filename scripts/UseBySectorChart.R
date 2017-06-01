library(plotly)
library(dplyr)
library(tidyr)

# Read in data
energy.use <- read.csv("../data/clean/use_by_sector.csv", stringsAsFactors = FALSE)

# Add sector as column
sectors <- list("A" = "Transportation",
                "C" = "Commercial",
                "I" = "Industrial",
                "R" = "Residential")

types <- read.csv("../data/energy_use_types.csv", stringsAsFactors = FALSE)

my.year <- 2014

energy.use <- mutate(energy.use, Sector = as.character(sectors[substring(MSN, 3, 3)])) %>% 
              filter(Sector != "NULL") %>% 
              mutate(Type = substring(MSN, 1, 2))

energy.use.clean <- energy.use %>% gather(year, use, X1960:X2014, convert = TRUE) %>% 
                    mutate(year = as.numeric(gsub("X", "", year))) %>% 
                    select(-X, -State, -MSN) %>% 
                    filter(year == my.year) %>% 
                    left_join(types, by = "Type") %>% 
                    select(-Type, -year)

if (state == "Overall") {
  energy.use.filtered <- energy.use.clean %>% group_by(Sector, Name) %>% summarize(use = sum(use, na.rm = TRUE))
} else {
  energy.use.filtered <- energy.use.clean %>% filter(StateName == state)
}

filtered <- energy.use.filtered %>% spread(Name, use) %>% select(-NA)
filtered[is.na(filtered)] <- 0
colnames(filtered) <- gsub(" ", "_", colnames(filtered))
colnames(filtered) <- gsub(",", "", colnames(filtered))
colnames(filtered) <- gsub("\"", "", colnames(filtered))

p <- plot_ly(data = filtered, type = "bar")

# loops through each type of energy given
for (energy in colnames(filtered)[-1][-46]) {
  temp <- filtered %>% select_(energy)
  p <- p %>% add_trace(data = temp, x = ~Sector, y = ~use, hoverinfo = 'text',
                       hovertext = ~paste0("<b>", gsub("_", " ", Name), "</b><br>Consumption: ", use, " billion Btu"))
  
}
