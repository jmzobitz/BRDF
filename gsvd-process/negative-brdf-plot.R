# This creates a graphic of the calculated kernel weights (ls) to the MCD43 kernel weights,
# Determine how many kernel weights are negative

load('../Saved-Files-12.08/fluxnet-ls-results.Rda')

ls_results_renamed <- ls_results %>%
  rename("0"=K_Iso,"1"=K_RossThick,"2"=K_LiSparse) %>%
  gather(key=kernel,value=value,"0","1","2")


# clean up the modis data and our GSVD data, joining them together
mcd43A1_data <- modisBRDF %>%
  rename(MCD43A1 = value)

short_results <- ls_results_renamed %>% left_join(mcd43A1_data,by=c("site","time","band","kernel"))

gsvd_data <- solution_list %>% bind_rows(.id="site") %>%
  mutate(method='GSVD',kernel=prepender_k(kernel)) %>%
  rename(GSVD=value) %>%
  select(-method)


kernel_data <- mcd43A1_data %>% left_join(gsvd_data,by=c("site","time","band","kernel"))



gsvd_results_renamed <- solution_list %>% bind_rows(.id="site")

# Join this to the solution list
summarized_data <- ls_results_renamed %>%
  left_join(gsvd_results_renamed,by=c("site","band","time","kernel")) %>%
  mutate(ls_neg = value.x<0,gsvd_neg = value.y<0,
         both_test = ls_neg+gsvd_neg)%>%
  mutate(both_test=ifelse(ls_neg & !gsvd_neg,3,both_test),
         both_test=ifelse(!ls_neg & gsvd_neg,4,both_test)) %>% # if both are bad, then this equals 2.  If one is bad, it equals 1, and if both are good, it equals 0
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
        axis.title=element_text(size=28),
        title=element_text(size=26),
        legend.text=element_text(size=12),
        legend.title=element_text(size=16)) +
  theme(legend.position="bottom") +
  theme(strip.text.x = element_text(size=12),
        strip.text.y = element_text(size=12)) +
  theme(strip.background = element_rect(colour="white", fill="white")) +
  scale_x_discrete(limits=rev(c("0","3","4","2")),
                   labels=rev(c("Laplace > 0; GSVD > 0", "Laplace < 0; GSVD > 0", "Laplace > 0; GSVD < 0", "Laplace < 0 ; GSVD < 0"))) + coord_flip() +
  scale_fill_discrete(name="Kernel Weights",
                      labels=c("Isotropic","Volumetric","Geometric")) +
  theme( panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))

fileName <- paste0('manuscript-figures/negativePlot.png')
ggsave(fileName,plot=negative_plot,width=14,dpi=600)
