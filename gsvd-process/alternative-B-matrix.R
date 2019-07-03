# Scratch work on developing an alternative B matrix

in_vec <- c(-1,1)
newDim <- 365*3
v<-  rep(0,length=newDim)
v[1:length(in_vec)] <- in_vec

formB_mat <- function(in_vec,newDim,kernelSize) {
  v<-  rep(0,length=newDim)
  v[1:length(in_vec)] <- in_vec
  out_B <- array(0,dim=c(newDim,newDim))

  for(i in 1:(newDim-1)) {
    out_B[i+1,] <- lag(v,i-1,default=0)
  }

 # zeroRows = seq(1,newDim,by=kernelSize)
#  out_B[zeroRows,]=0  # Make sure we don't go across the timestep


  return(out_B)
}

