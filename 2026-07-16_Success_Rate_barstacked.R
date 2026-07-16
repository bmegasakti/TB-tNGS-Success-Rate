############################################################
## Success rate of tNGS by AFB smear grade and HIV status
############################################################

library(tidyverse)

############################################################
## Read data
############################################################

df <- read.csv(
  "2026-07-15_AFB.csv",
  sep = ";",
  stringsAsFactors = FALSE
)

############################################################
## Clean column names
############################################################

names(df)[names(df)=="Identifiable."] <- "Identifiable"

############################################################
## Clean variables
############################################################

df <- df %>%
  mutate(
    AFB = trimws(AFB),
    HIV = trimws(HIV),
    Platform = trimws(tNGS_platform),
    Success = trimws(Identifiable)
  )

############################################################
## Exclude unwanted categories
############################################################

df <- df %>%
  filter(
    AFB %in% c("Neg","Scanty","1+","2+","3+"),
    HIV %in% c("Negatif","Positif"),
    Platform %in% c("ONT","GS")
  )

############################################################
## AFB summary
############################################################

afb <- df %>%
  group_by(Platform,AFB) %>%
  summarise(
    n=n(),
    Successful=sum(Success=="Yes"),
    Unsuccessful=sum(Success=="No"),
    .groups="drop"
  ) %>%
  mutate(
    Successful=Successful/n,
    Unsuccessful=Unsuccessful/n,
    Variable=case_when(
      AFB=="Neg"~"AFB negative",
      AFB=="Scanty"~"AFB scanty",
      TRUE~paste0("AFB ",AFB)
    )
  )

############################################################
## HIV summary
############################################################

hiv <- df %>%
  group_by(Platform,HIV) %>%
  summarise(
    n=n(),
    Successful=sum(Success=="Yes"),
    Unsuccessful=sum(Success=="No"),
    .groups="drop"
  ) %>%
  mutate(
    Successful=Successful/n,
    Unsuccessful=Unsuccessful/n,
    Variable=ifelse(
      HIV=="Negatif",
      "HIV negative",
      "HIV positive"
    )
  )

############################################################
## Combine summaries
############################################################

plot.df <- bind_rows(
  
  afb %>%
    select(Platform,Variable,n,Successful,Unsuccessful),
  
  hiv %>%
    select(Platform,Variable,n,Successful,Unsuccessful)
  
)

############################################################
## Order variables
############################################################

plot.df$Variable <- factor(
  plot.df$Variable,
  levels=c(
    "AFB negative",
    "AFB scanty",
    "AFB 1+",
    "AFB 2+",
    "AFB 3+",
    "HIV negative",
    "HIV positive"
  )
)

############################################################
## Labels with sample size
############################################################

plot.df <- plot.df %>%
  mutate(
    Label=paste0(
      Variable,
      " (n=",
      n,
      ")"
    )
  )

############################################################
## Long format
############################################################

plot.long <- plot.df %>%
  pivot_longer(
    cols=c(Successful,Unsuccessful),
    names_to="Result",
    values_to="Proportion"
  )

plot.long$Result <- factor(
  plot.long$Result,
  levels=c("Successful","Unsuccessful")
)

############################################################
## Keep order within each platform
############################################################

plot.long <- plot.long %>%
  arrange(Platform,Variable)

plot.long$Label <- factor(
  plot.long$Label,
  levels=rev(unique(plot.long$Label))
)

############################################################
## Plot
############################################################

p <- ggplot(
  plot.long,
  aes(
    x=Label,
    y=Proportion,
    fill=Result
  )
)+
  
  geom_col(width=.75)+
  
  coord_flip()+
  
  facet_grid(
    Platform~.,
    scales="free_y",
    space="free_y"
  )+
  
  scale_fill_manual(
    values=c(
      Successful="#43aec4",
      Unsuccessful="#bf5757"
    ),
    labels=c(
      "Successful result",
      "Unsuccessful result"
    )
  )+
  
  scale_y_continuous(
    limits=c(0,1),
    breaks=seq(0,1,0.25),
    labels=scales::percent_format(accuracy=1),
    expand=c(0,0)
  )+
  
  labs(
    x=NULL,
    y="Proportion (%)",
    fill=NULL
  )+
  
  theme_classic(base_size=12)+
  
  theme(
    
    strip.background=element_blank(),
    
    strip.text.y=element_text(
      face="bold",
      size=13
    ),
    
    axis.text.y=element_text(size=10),
    
    axis.title.x=element_text(size=12),
    
    legend.position="right",
    
    legend.title=element_blank(),
    
    panel.spacing=unit(1.2,"lines")
    
  )

############################################################
## Display
############################################################

print(p)

############################################################
## Save
############################################################

ggsave(
  "Success_rate_AFB_HIV.png",
  p,
  width=8,
  height=7,
  dpi=600
)