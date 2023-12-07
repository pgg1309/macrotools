# data-raw/nber_recession.R
# Import recession dates from NBER
# http://data.nber.org/data/cycles/


library(tidyverse)
raw <- read.csv(here::here("data-raw", "20210719_cycle_dates_pasted.csv"), stringsAsFactors = FALSE, strip.white = TRUE)

nber.recession <- as_tibble(raw) %>%
  mutate(
    peak   = lubridate::as_date(peak),
    trough = lubridate::as_date(trough)
    )

usethis::use_data(nber.recession, overwrite = TRUE)
