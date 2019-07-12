# This creates a graphic of how many kernels are similar,
# Determine how many kernel weights are negative

ls_results_renamed <- ls_results %>%
  rename("0"=K_Iso,"1"=K_RossThick,"2"=K_LiSparse) %>%
  gather(key=kernel,value=value,"0","1","2")

gsvd_results_renamed <- solution_list %>% bind_rows(.id="site")

# Join this to the solution list
summarized_data <- ls_results_renamed %>%
  left_join(gsvd_results_renamed,by=c("site","band","time","kernel")) %>%
  mutate(ls_zero = value.x==0,gsvd_neg = value.y<0,
         both_test = ls_zero+gsvd_neg)%>%
  mutate(both_test=ifelse(ls_zero & !gsvd_neg,3,both_test),
         both_test=ifelse(!ls_zero & gsvd_neg,4,both_test)) %>% # if both are bad, then this equals 2.  If one is bad, it equals 1, and if both are good, it equals 0
  #group_by(site,band,kernel,both_test) %>%
  group_by(kernel,both_test) %>%
  summarize(tot=n())


negative_plot <- summarized_data %>%
  ggplot() +
geom_bar(aes(x=as.factor(both_test),y=tot,fill=kernel),stat="identity",
         position = "dodge") +
  labs(x="", y="N",fill="Kernel") +
  theme_bw() +
  theme(axis.text = element_text(size=14),
        axis.title=element_text(size=24),
        title=element_text(size=26),
        legend.text=element_text(size=12),
        legend.title=element_text(size=16)) +
  theme(legend.position="bottom") +
  theme(strip.text.x = element_text(size=12),
        strip.text.y = element_text(size=12)) +
  theme(strip.background = element_rect(colour="white", fill="white")) +
  theme( panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
  scale_x_discrete(limits=rev(c("0","3","4","2")),
                   labels=rev(c("WLS > 0; GSVD > 0", "WLS = 0; GSVD > 0", "WLS > 0; GSVD = 0", "WLS = 0 ; GSVD < 0"))) + coord_flip() +
  scale_fill_discrete(name="Kernel Weights",
                      labels=c(as.expression(bquote(bolditalic(f)[iso])),as.expression(bquote(bolditalic(f)[vol])),as.expression(bquote(bolditalic(f)[geo])))) +
  theme( panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))




fileName <- paste0('manuscript-figures/negativePlot.png')
ggsave(fileName,plot=negative_plot,width=14)
