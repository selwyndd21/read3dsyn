File description
==============================
Scripts:
  1_1DTotalFlux.sh + Adding1D.py
  2_2DTotalFlux.sh + Adding2D.py
  3_3DSynthesis.py
  4_MaxSearching.sh + Search_Max.py
Test inputs and outputs
分別是兩個DORT的輸出檔，（二維R-Z與R-theta幾何）
以及一個ANISN輸出檔（一維R幾何）。
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
To make an 3-D synthesis flux, 
1. use 1_1DTotalFlux.sh to extract R dependent flux.
  $ sh 1_1DTotalFlux.sh input_anisn.out
2. use 2_2DTotalFlux.sh to extract R-Theta and R_Z dependent flux
  $ sh 2_2DTotalFlux.sh -t input_dort_rt.out -z input_dort_rz.out
3. use 3_3DSynthesis.py to make 3-D synthesis 
  $ python 3_3DSynthesis.py TotalFlux_RT.txt TotalFlux_RZ.txt TotalFlux_R.txt

4. use 4_MaxSearching.sh to find local maximun flux in interested region
  $ sh 4_MaxSearching.sh 
  To change interested region, change the variables in the script
