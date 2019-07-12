# Figure 1: Make a simple L-Curve plot for the figures.  This is easily generalizable if we want it to be.

site <- 'AU-Lox'
data <- fluxnet %>% filter(site==site)
kernel_data <- kernel_matrix(site)
gsvd_data <- gsvd_list[[site]]
nLambda <- 100
lambda_init <- c(0,lseq(1E-6,1E3,length.out=nLambda-1))  # Do a logarithmic sequence initially to hone in

# Just select the select the second band
rho_curr <- kernel_data$rho %>% filter(band=='band2')
sigma <- band_uncertainty %>% filter(band=='band2') %>% select(sigma) %>% as.numeric()

out_values <- gsvd_norm(gsvd_data,lambda_init,rho_curr)




# L curve plot
p<-out_values %>% spread(key=norm,value=result) %>% ggplot() +
  geom_point(aes(y=solution,x=residual),size=4) +
  geom_vline(xintercept = sigma,color='red',size=1,linetype=2) +
  labs(y=expression(paste("||",bold(B),bolditalic(f),"||")), x=expression(paste("||",bolditalic("\u03B5"),"||")))  +
  theme_bw() +
  theme(axis.text = element_text(size=14),
        axis.title=element_text(size=28,face='bold')) +
  annotate("text", x = .08, y = .55, label = expression(paste("Increasing ",italic("\u03BB"))),size=8) +
  annotate("segment", x = .07, xend = .13, y = .5, yend = .5, colour = "black", size=1.5, arrow=arrow()) + xlim(c(0,0.2)) +
  theme( panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))





fileName <- paste0('manuscript-figures/lCurve.png')
ggsave(fileName,plot=p,dpi=600)
