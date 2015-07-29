File description
==============================
Scripts:
  1_1DTotalFlux.sh + Adding1D.py
  2_2DTotalFlux.sh + Adding2D.py
  3_3DSynthesis.py
  4_MaxSearching.sh + Search_Max.py
  5_1DEachGroup.sh + Adding1D.py
  6_2DEachGroup.sh + Adding2D.py
  7_3DSynEg.sh + ThreeDSynthesis.py
Test inputs and outputs
���O�O���DORT����X�ɡA�]�G��R-Z�PR-theta�X��^
�H�Τ@��ANISN��X�ɡ]�@��R�X��^�C
  input_anisn.out   -> TotalFlux_R.txt
  input_dort_rt.out -> TotalFlux_RT.txt
  input_dort_rz.out -> TotalFlux_RZ.txt
Readme file
  README.txt


Environment requirement
==============================
*Python 2.7+ with Numpy 1.7+
*bash

Execution method
==============================
To make an 3-D synthesis total Flux
1. use 1_1DTotalFlux.sh to extract R dependent flux.
  $ sh 1_1DTotalFlux.sh input_anisn.out
2. use 2_2DTotalFlux.sh to extract R-Theta and R_Z dependent flux
  $ sh 2_2DTotalFlux.sh -t input_dort_rt.out -z input_dort_rz.out
3. use 3_3DSynthesis.py to make 3-D synthesis 
  $ python 3_3DSynthesis.py RT_TotalFlux.txt RZ_TotalFlux.txt R_TotalFlux.txt

4. use 4_MaxSearching.sh to find local maximun flux in interested region
  $ sh 4_MaxSearching.sh 
  To change interested region, change the variables in the script

  
Similary, to make 3D synthesis flux for every group, 
$ sh 5_1DEachGroup.sh input_anisn.out
$ sh 6_2DEachGroup.sh -t input_dort_rt.out -z input_dort_rz.out
$ sh 7_3DSynEg.sh 
Final results flux will placed in the folder "ThetaData", and separated by different theta.
Each file is an 512*111 (Z-R) array.