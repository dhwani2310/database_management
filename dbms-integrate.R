library(readxl)
library(dplyr)
library(writexl)
setwd("D:/UNH/SEMESTER 2/DATABASE MANAGEMENT/FLEETCORE PROJECT/Fleetcor Project 1_Data-1")

# Load data
all <- read_excel("All Acct Segment Score.xlsx")
CSA <- read_excel("Cross-Sell Acct.xlsx")
nsl_Acct <- read_excel("Non Cross-Sell Acct Info.xlsx")
nsl_aging <- read_excel("Non Cross-Sell Aging Data.xlsx")
nsl_payment <- read_excel("Non Cross-Sell Payment.xlsx") %>% distinct(Account_ID, .keep_all = TRUE)
nsf_payment <- read_excel("Non Cross-Sell Payment.xlsx") %>% distinct(Account_ID, .keep_all = TRUE)
revenue <- read_excel("Non Cross-Sell Revenue.xlsx") %>% distinct(Account_ID, .keep_all = TRUE)
vantage_score <- read_excel("Non Cross-Sell Vantage Score.xlsx")
nsl_spend <- read_excel("Non Cross-Sell Spend.xlsx")
writeOff <- read_excel("Non Cross-Sell Write-Off.xlsx")

common_col <- "FAKE_ACCTCODE"  # Replace with your actual column name

# Merge datasets in chunks (clearing memory after each step)
merged_df <- all %>%
  left_join(CSA, by = common_col)

rm(CSA)  # Remove unnecessary data to free memory

merged_df <- merged_df %>%
  left_join(nsl_Acct, by = common_col) %>%
  left_join(nsl_aging, by = common_col)

rm(nsl_Acct, nsl_aging)

merged_df <- merged_df %>%
  left_join(nsl_payment, by = common_col) %>%
  left_join(nsf_payment, by = common_col)

rm(nsl_payment, nsf_payment)

merged_df <- merged_df %>%
  left_join(revenue, by = common_col) %>%
  left_join(vantage_score, by = common_col)

rm(revenue, vantage_score)

merged_df <- merged_df %>%
  left_join(nsl_spend, by = common_col) %>%
  left_join(writeOff, by = common_col)

rm(nsl_spend, writeOff)

gc()  # Run garbage collection to free memory

# Save merged data
write_xlsx(merged_df, "Merged_Output.xlsx")

# Print success message
print("Merge completed successfully!")
head(merged_df)
