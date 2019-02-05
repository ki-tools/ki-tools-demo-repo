## set up clean slate test project
d <- file.path(tempfile(), "0a-test-sprint-analysis")
dir.create(d, recursive = TRUE)
file.copy("_ignore/test_project2.R", d)
system(paste0("code -n ", d))
## end set up clean slate test project

lp <- function() {
  load_all("~/Documents/code/kitools")
  get_config()
}
lp()

## One time project Setup
## ______________________

# Initialize an analysis project
# - Prompts for your Synapse ID (if not already supplied), Synapse space ID, title of project
# - Stores these values in a project-level configuration file
# - Sets up a minimal directory structure
create_analysis(title = "test analysis", synid = "syn17013688")

# Set this project up on GitHub
usethis::use_git()
usethis::use_github(organisation = "ki-analysis", protocol = "https")

# This will pull a core dataset, "CPP", located here:
# https://www.synapse.org/#!Synapse:syn17100911
# and register it with your project
data_pull("syn17100911")
# We now have a local copy in data/core/cpp.csv
# and it has been registered in project_config.yml

system("code data/scripts/cpp_n.R")

# Suppose we do some simple analysis to the CPP data
# and produce a "derived" dataset.
# For example, compute the number of records per subject.

# See what datasets are available
data_list()
# Note: you can also look at project_config.yml

# Load the registered cpp dataset into our environment and analyze it:
cpp <- data_use("cpp")
# Note: can also load by Synapse ID:
# cpp <- data_use("syn17100911")

# Take a look at the data
cpp

library(dplyr)
cpp_n <- cpp %>%
  group_by(subjid) %>%
  tally()

# We may want to register this derived dataset with our project
# so it's available for others to use without having to re-compute it
data_publish(cpp_n, name = "cpp_n",
  desc = "Number of records per subject for CPP data",
  type = "derived", file_type = "csv",
  used = "syn17100911")

data_list()

data_view("syn17101011")


## Now illustrate how this works with multiple users
## (commit files and clone to new location to simulate new user)

dir.create("R/cpp", recursive = TRUE)
system("code R/cpp/n_subject_vis.R")

load_all("~/Documents/code/kitools")

cpp_n <- data_use("cpp_n")

plot(sort(cpp_n$n))
