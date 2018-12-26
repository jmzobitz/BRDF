sec <- function(angle) {
  return(1/cos(angle))
}


correct_angles<-function( .sza, .vza, .raa ) {
#Returns "corrected" angles
#All angles in radians.
#Tristan 9/06/08
  .vaa = 0
  .saa = .raa
  
  if( .vza < 0.0 ) {
    .vaa=.vaa+pi;
    .vza=-1.0*.vza;
  }

  if( .sza < 0.0 ) {
    .saa=.saa+pi ;
    .sza=-1.0*.sza;
  }
  
  while( .saa > 2 * pi ) {
      .saa = .saa-2 * pi;
  }

  while( .vaa > 2 * pi ) {
        .vaa =.vaa - 2 * pi;
  }
  
  while( .saa < 0 ) {
    .saa = .saa+2 * pi;
  }
  
  while ( .vaa < 0 ) {
      .vaa =.vaa+ 2 * pi;
  }
      
  .raa = .saa - .vaa ;
  .raa = abs((.raa - 2 * pi *  round(0.5 + .raa * 0.5 / pi )));
            
  return(data.frame(".raa"=.raa,".sza" = .sza,".vza"=.vza))
}






phase_angle<- function( .sza, .vza, .raa ) {
#Returns the phase angle.
#Common radtiative trnsfer maths.
#All angles in radians.
#Tristan 7/11/99


  
  
  testAngle <- ( cos( .vza )*cos( .sza ) + sin(.vza) * sin(.sza) * cos(.raa) )

# Calculate phase angle:

PhaseAngle = acos( testAngle )
#if(testAngle>=1) {
#  print(c(.vza,.sza,.raa))
#  PhaseAngle = 0
#} else {
#  PhaseAngle = acos( testAngle )
#}

return(PhaseAngle)

}


ross_thick_k<-function( .sza, .vza, .raa ) {
# The Ross thick volumetric kernel
# from ambrals. As defined in 
# "On the derivation ..." 
# by Wanner, Li and Strahler.
# Tristan 7/11/99 



  
# Get phase angle:

phase = phase_angle( .sza, .vza, .raa );

# Calculate the value of the Roujean kernel:

KRossThick = (((((pi/2)-phase)*cos(phase))+sin(phase))/(cos(.vza)+cos(.sza)))-(pi/4);

return(KRossThick)
}


li_t<- function( .sza_primed, .vza_primed, .raa, h_b ) {
#Returns the t value which parameterizes
#parts of the Li value of kernels.
#Take note of the comments about the acos
#function below.
#Tristan 7/11/99.


#Call the distance function:

dist=li_distance(.sza_primed, .vza_primed, .raa );

#Calculate the value of T:

cos_t=h_b*(sqrt(dist^2+(tan(.sza_primed )*tan(.vza_primed )*sin(.raa ) )^2) )/(sec(.sza_primed )+sec(.vza_primed ));

#NB - here I have forced only the real part of
#the value returned from the acos function to
#be used. Some times imaginary parts are introduced 
#when the argument is greater than one. This 
#results in warning messages from octave.
#Is this a problem with the model?

# JZ Notes: we add the 0i to make it imaginary, so then it can do the acos
if (cos_t >1) { cos_t=1}
T_angle=acos(cos_t);

return(T_angle)
} 


li_distance<-function( .sza_primed, .vza_primed, .raa ) {
# calculate the distance measure used in the Li family of 
# geometric kernels for Ambrals BRDF. All arguments need
# to be in radians.

# Tristan 5/11/99

# Sanity checking:


# Calculate distanace:

Dist=sqrt( tan(.sza_primed )^2 + tan(.vza_primed )^2 - 2*tan(.sza_primed )*tan(.vza_primed )*cos(.raa ) );

return(Dist)
}


li_overlap<-function( .sza, .vza, .raa, h_b, b_r ) {
#Calculates the area of overlap of
#tree crown shadows - used by the
#Li family of kernels.
#Tristan 7/11/99

# Sanity checking:

#Prime the zenith angles and
#calculate the t parameter:

.sza_primed=li_prime_theta( .sza, b_r );
.vza_primed=li_prime_theta( .vza, b_r );
.t=li_t( .sza_primed, .vza_primed, .raa, h_b );

#Calculate the actual overlap:

Overlap = (1/pi)*(.t - sin(.t)*cos(.t))*(sec(.sza_primed)+sec(.vza_primed ));

return(Overlap)
}


li_prime_theta<-function( .theta, b_r ) {
#Calculates the "equivelant" zenith angle at which
#a sphere of radius r will would have to be illuminated
#to produce the same shadow as the spheroid does when
#illuminated at the actual angle theta.
#b=1/2vertical length of spheroid.
#Tristan 7/11/99


#Calculate theta primed:

theta_primed = atan( b_r*tan( .theta ) );

return(theta_primed)

}


li_sparse_k<-function( .sza, .vza, .raa, h_b, b_r ) {
#The Li Sparse kernel as defined in:
#On the derivation of kernels for kernel-driven models of bidirectional reflectance
#Wanner, W., Li, X. and Strahler, A. H.
#Note this kernel is not linear because of the h/b and b/r
#values. This problem is solved by using a "family" of these
#kernels with set values of these variables.
#Tristan 7/11/99 


# Calculate various required values:

.sza_primed=li_prime_theta( .sza, b_r );
.vza_primed=li_prime_theta( .vza, b_r );
phase_primed=phase_angle( .sza_primed, .vza_primed, .raa );
Overlap=li_overlap( .sza, .vza, .raa, h_b, b_r );

# Calculate the actual value of the Li Sparse kernel:

KLiSparse = Overlap - sec(.sza_primed ) - sec(.vza_primed ) + 0.5*(1 + cos( phase_primed ))*sec(.vza_primed )*sec(.sza_primed);

}


