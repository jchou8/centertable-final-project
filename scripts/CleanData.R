# Load libraries
library(dplyr)

# Load in data sets
state.codes <- read.csv("../data/state_codes.csv", stringsAsFactors = FALSE)
msn.codes <- read.csv("../data/codes_and_descriptions.csv", stringsAsFactors = FALSE)
energy.use <- read.csv("../data/use_all_btu.csv", stringsAsFactors = FALSE)
energy.prod <- read.csv("../data/prod_all.csv", stringsAsFactors = FALSE)
energy.expense <- read.csv("../data/ex_all.csv", stringsAsFactors = FALSE)

# Filter data categories to only the categories we're interested in
msn.codes <- msn.codes %>% filter(Unit == "Billion Btu" | Unit == "Million dollars") %>% 
                           filter((substr(MSN, 3, 3) == "T" & substr(MSN, 4, 4) == "C") | substr(MSN, 3, 5) == "PRB" | MSN == "NGMPB" | 
                                   MSN == "NUETV") %>% 
                           select(-Unit)


# Join and filter datasets
energy.use <- inner_join(energy.use, msn.codes, by = "MSN") %>% 
              inner_join(state.codes, by = "State") %>% 
              select(-Data_Status)

energy.prod <- inner_join(energy.prod, msn.codes, by = "MSN") %>% 
               mutate(State = StateCode) %>% 
               select(-StateCode) %>% 
               inner_join(state.codes, by = "State") %>% select(-ï..Data_Status)

energy.expense <- inner_join(energy.expense, msn.codes, by = "MSN") %>% 
                  inner_join(state.codes, by = "State") %>% 
                  select(-Data_Status)

# Export data
write.csv(energy.use, file = "../data/clean/use_clean.csv")
write.csv(energy.prod, file = "../data/clean/prod_clean.csv")
write.csv(energy.expense, file = "../data/clean/expense_clean.csv")
