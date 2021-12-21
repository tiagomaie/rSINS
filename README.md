
# rSINS

<!-- badges: start -->
<!-- badges: end -->

The goal of rSINS is simply to load the SQLite databases generated by SINS.

## Installation

You can install the development version of rSINS like so:

``` r
devtools::install_github("tiagomaie/rSINS")
```

## Example

These are some basic examples which shows you how to solve common problems.

Checking which tables and fields are available in the SINS db data:
``` r
library(rSINS)

db_dir <- "~/Projects/SINS/output/Your_SINS_Project"
peak_db(db_dir)
```

Loading SINS db data from generation 1000 and deme [4,4]:
``` r
my_q <- "SELECT * FROM sinsdata WHERE generation = 1000 AND demex = 4 AND demey = 4"
res <- get_sins_res(query=my_q, db_dir=db_dir)
```

Loading all generations available in the SINS db into a vector:
``` r
my_q <- "SELECT DISTINCT generation FROM sinsdata"
res <- get_sins_res(query=my_q, db_dir=db_dir)
generations  <- unique(unlist(res))
```

Loading the number (count) of individuals for each simulation replicate and for each generation, for the generations that we generated in the previous example.
Then creating a simple plot with mean number of individuals as well as the number for each simulation replicate.
``` r
my_q1 <- "SELECT simulationid, COUNT(individualid), generation FROM sinsdata WHERE generation=? AND demex = 0 AND demey = 0"
res <- get_sins_res(query=my_q1, db_dir=db_dir,params=list(generations))

all_res <- Reduce(rbind, res)
mean_res <- all_res %>%
  group_by(generation) %>%
  summarize(mean=mean(`COUNT(individualid)`))

ggplot(all_res,aes(x=generation,y=`COUNT(individualid)`,group=simulationid))+
  geom_line(alpha=0.2) +
  geom_line(inherit.aes = FALSE,data=mean_res,aes(x=generation,y=mean)) +
  labs(y="N individuals at deme 0,0", x="Generations") +
  theme_classic()
```


Loading all the data from the 'sinsstats' table.
Summarizing the data (heterozygosity) as mean per simulation replicate and generating a plot with the results.
``` r
my_q <- "SELECT * FROM sinsstats"
res <- get_sins_res(query=my_q, db_dir=db_dir)

sstats <- Reduce(rbind,res)

sstats %>% head
sstats <- sstats %>% select(simulationid,layer,generation,genmarker,heterozygosity)%>%
  group_by(layer,genmarker,generation) %>%
  mutate(heterozygosity=as.numeric(heterozygosity))

msstats <- sstats%>%summarize(mean=mean(heterozygosity))


ggplot(sstats,aes(
    x=generation,
    y=heterozygosity,
    color=genmarker,group=paste0(simulationid,genmarker)))+
geom_line(alpha=0.2) +
geom_line(inherit.aes=F,data=msstats,aes(x=generation,y=mean,color=genmarker,group=genmarker))+
labs(y="He", x="Generations") +
scale_colour_viridis_d() +
theme_classic()
```

