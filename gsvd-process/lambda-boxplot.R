# Now we can start processing figures - yay!

# Figure 8: histogram of gsvd files

library(BRDF)
library(tidyverse)

band_labels = 1:7

#ggplot(df,aes(x,y)) + geom_point() +
#  scale_x_discrete(breaks = 1:5, labels = letters[1:5])


nConverged <- lambda_list %>% bind_rows() %>%
  filter(converged) %>%
  group_by(band) %>% summarize(tot=n()) %>%
  mutate(tot=paste("=",tot))

n_name <- data.frame(val="N",band=nConverged$band)
lambda_boxplot <- lambda_list %>% bind_rows() %>%
  filter(converged) %>%
  ggplot() +
  geom_boxplot(aes(x=band,y=lambda)) +
  geom_text(data=nConverged,aes(x=band,y=28,label=tot),size=4) +
  geom_text(data=n_name,aes(x=band,y=28,label=val),fontface="italic",hjust='left',nudge_x = -0.3) +
  scale_x_discrete(labels=1:7)+
  labs(x="Band",y=expression(italic("\u03BB"))) +
  theme_bw() +
  theme(axis.text = element_text(size=10),
        axis.title=element_text(size=16),
        title=element_text(size=26),
        legend.text=element_text(size=12),
        legend.title=element_text(size=16)) +
  ylim(c(0,30)) +
  theme( panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))

fileName <- paste0('manuscript-figures/boxplot.png')
ggsave(fileName,plot=lambda_boxplot)

