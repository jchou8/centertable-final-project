library(plotly)
library(dplyr)
library(tidyr)

# Read in data
energy.use <- read.csv("../data/clean/use_by_sector.csv", stringsAsFactors = FALSE)

# Add sector as column
sectors <- list("A" = "Transportation",
                "C" = "Commercial",
                "E" = "Electric",
                "I" = "Industrial",
                "R" = "Residential")

types <- read.csv("../data/energy_use_types.csv", stringsAsFactors = FALSE)
exclude.types <- c("DK", "JK", "JN", "LO", "ES", "MM", "EM", "EN", "NA", "NN", "P1", "PM", "PO", "RE", "WW", "TE", "TN", "AB", "MB", 
                   "AR", "AV", "DF", "JF", "KS", "LG", "LU", "MG", "PC", "RF", "CO", "MS", "FN", "FO", "FS", "PL", "PP", "SN", "SG",
                   "US", "WX", "UO")
my.year <- 2014
state <- "Overall"

energy.use <- mutate(energy.use, Sector = as.character(sectors[substring(MSN, 3, 3)])) %>% 
              filter(Sector != "NULL") %>% 
              mutate(Type = substring(MSN, 1, 2)) %>% 
              filter(!Type %in% exclude.types)

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
colnames(filtered) <- gsub("-", "_", colnames(filtered))
colnames(filtered) <- gsub("[\\(\\)]", "", colnames(filtered))

p <- plot_ly(data = filtered, type = "bar", orientation = "h")

# loops through each type of energy given
for (energy in colnames(filtered)[-1]) {
  temp.data <- filtered %>% mutate_(use = energy)
  energy.name <- gsub("_", " ", energy)
  p <- p %>% add_trace(data = temp.data, y = ~Sector, x = ~use, hoverinfo = 'text', name = energy.name,
                       hovertext = ~paste0("<b>", energy.name, "</b><br>Consumption: ", use, " billion Btu"))
}

p <- p %>% layout(barmode = "stack", yaxis = list(title = "Sector"), xaxis = list(title = "Consumption (Billion Btu)"), margin = list(l = 200))
p