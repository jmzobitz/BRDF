# Now we can start processing figures - yay!

# Figure 8: histogram of gsvd files

library(BRDF)
library(tidyverse)

band_labels = 1:7

ggplot(df,aes(x,y)) + geom_point() +
  scale_x_discrete(breaks = 1:5, labels = letters[1:5])


lambda_boxplot <- lambda_list %>% bind_rows() %>%
  filter(converged) %>%
  ggplot() +
  geom_boxplot(aes(x=band,y=lambda)) +
  scale_x_discrete(labels=1:7)+
  labs(x="Reflectance Band",y=expression(lambda)) +
  theme(axis.text = element_text(size=10),
        axis.title=element_text(size=16),
        title=element_text(size=26),
        legend.text=element_text(size=12),
        legend.title=element_text(size=16))

fileName <- paste0('manuscript-figures/boxplot.png')
ggsave(fileName,plot=residual_plot,width=14,height=4)

